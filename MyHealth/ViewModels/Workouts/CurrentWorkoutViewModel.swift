//
//  CurrentWorkoutViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import CoreLocation
import Foundation
import Models

@MainActor
public final class CurrentWorkoutViewModel: ObservableObject {
    @Published public private(set) var currentSession: WorkoutSession?
    @Published public private(set) var errorMessage: String?
    @Published public private(set) var elapsedText: String?
    @Published public private(set) var routePoints: [WorkoutRoutePoint]
    @Published public private(set) var currentLocationPoint: WorkoutRoutePoint?
    @Published public private(set) var splits: [WorkoutSplit]
    @Published public private(set) var distanceText: String
    @Published public private(set) var paceText: String
    @Published public private(set) var speedText: String
    @Published public private(set) var availableTypes: [WorkoutType]
    @Published public private(set) var gpsStatusText: String?
    @Published public private(set) var hasGoodGpsFix: Bool
    @Published public private(set) var locationAuthorizationStatus: CLAuthorizationStatus
    
    private let service: WorkoutFlowServiceProtocol
    private let locationService: LocationServiceProtocol
    private let workoutLocationManager: WorkoutLocationManaging
    private var task: Task<Void, Never>?
    private var locationTask: Task<Void, Never>?
    private var authorizationTask: Task<Void, Never>?
    private var timerCancellable: AnyCancellable?
    private let gpsAccuracyThreshold: Double = 25
    
    public init(
        service: WorkoutFlowServiceProtocol,
        locationService: LocationServiceProtocol,
        workoutLocationManager: WorkoutLocationManaging
    ) {
        self.service = service
        self.locationService = locationService
        self.workoutLocationManager = workoutLocationManager
        self.currentSession = nil
        self.errorMessage = nil
        self.elapsedText = nil
        self.routePoints = []
        self.currentLocationPoint = nil
        self.splits = []
        self.distanceText = "—"
        self.paceText = "—"
        self.speedText = "—"
        self.availableTypes = WorkoutType.outdoorSupported
        self.gpsStatusText = nil
        self.hasGoodGpsFix = false
        self.locationAuthorizationStatus = locationService.currentAuthorizationStatus()
    }
    
    public func startWorkout(type: WorkoutType) {
        service.startWorkout(type: type)
    }
    
    public func start() async {
        for await update in service.updates() {
            guard !Task.isCancelled else { break }
            self.currentSession = update.currentSession
            self.availableTypes = update.availableTypes
            self.configureTimer(for: update.currentSession)
            self.configureLocationUpdates(for: update.currentSession)
        }
    }
    
    public func stop() {
        task?.cancel()
        task = nil
        locationTask?.cancel()
        locationTask = nil
        authorizationTask?.cancel()
        authorizationTask = nil
        stopTimer()
    }
    
    public func endWorkout() async {
        do {
            try await service.endWorkout()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    public func pauseWorkout() {
        Task { [weak self] in
            guard let self else { return }
            do {
                try await service.pauseWorkout()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    public func resumeWorkout() {
        Task { [weak self] in
            guard let self else { return }
            do {
                try await service.resumeWorkout()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    public func beginWorkout() {
        Task { [weak self] in
            guard let self else { return }
            do {
                guard self.canStartWorkout else {
                    self.errorMessage = "Waiting for a GPS fix before starting."
                    return
                }
                try await service.beginWorkout()
            } catch let error {
                print(error)
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    public func clearError() {
        errorMessage = nil
    }
    
    public var isOutdoorSupported: Bool {
        guard let type = currentSession?.type else { return false }
        return type == .walking || type == .running || type == .cycling
    }

    public var canStartWorkout: Bool {
        guard let session = currentSession else { return false }
        if session.status != .notStarted { return true }
        return !isOutdoorSupported || hasGoodGpsFix
    }

    public var isLocationAuthorized: Bool {
        locationAuthorizationStatus == .authorizedWhenInUse || locationAuthorizationStatus == .authorizedAlways
    }

    public var isLocationDenied: Bool {
        locationAuthorizationStatus == .denied || locationAuthorizationStatus == .restricted
    }

    public func requestLocationAuthorization() {
        locationService.requestAlwaysAuthorization()
    }
    
    private func configureTimer(for session: WorkoutSession?) {
        guard let session else {
            stopTimer()
            elapsedText = nil
            return
        }
        
        updateElapsedText(session: session)
        if timerCancellable == nil {
            timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in
                    guard let self, !Task.isCancelled else { return }
                    if let session = self.currentSession {
                        self.updateElapsedText(session: session)
                    }
                }
        }
    }
    
    private func configureLocationUpdates(for session: WorkoutSession?) {
        guard session != nil, isOutdoorSupported else {
            locationTask?.cancel()
            locationTask = nil
            authorizationTask?.cancel()
            authorizationTask = nil
            routePoints = []
            currentLocationPoint = nil
            splits = []
            distanceText = "—"
            paceText = "—"
            speedText = "—"
            gpsStatusText = nil
            hasGoodGpsFix = false
            workoutLocationManager.reset()
            return
        }
        if authorizationTask == nil {
            authorizationTask = Task { [weak self] in
                guard let self else { return }
                for await status in locationService.authorizationUpdates() {
                    guard !Task.isCancelled else { break }
                    self.locationAuthorizationStatus = status
                    if self.isLocationAuthorized {
                        if let current = self.locationService.currentLocation() {
                            self.currentLocationPoint = current
                            self.updateGpsStatus()
                        }
                        self.startLocationUpdatesIfNeeded()
                    } else {
                        self.stopLocationUpdates()
                    }
                }
            }
        }

        startLocationUpdatesIfNeeded()
    }

    private func startLocationUpdatesIfNeeded() {
        guard isLocationAuthorized else {
            stopLocationUpdates()
            return
        }
        guard locationTask == nil else { return }
        locationService.startLocationUpdates()
        if let current = locationService.currentLocation() {
            currentLocationPoint = current
            updateGpsStatus()
        }
        gpsStatusText = "Waiting for GPS…"
        hasGoodGpsFix = false
        locationTask = Task { [weak self] in
            guard let self else { return }
            for await point in locationService.locationUpdates() {
                guard !Task.isCancelled else { break }
                self.currentLocationPoint = point
                self.updateGpsStatus()
                if self.currentSession?.status != .active { continue }
                if let accuracy = point.horizontalAccuracy, accuracy > self.gpsAccuracyThreshold {
                    continue
                }
                if self.workoutLocationManager.shouldAppend(point: point) {
                    self.routePoints.append(point)
                    self.updateMetrics()
                    do {
                        try await self.service.appendRoutePoint(point)
                    } catch {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }

    private func stopLocationUpdates() {
        locationTask?.cancel()
        locationTask = nil
        locationService.stopLocationUpdates()
        routePoints = []
        currentLocationPoint = nil
        splits = []
        distanceText = "—"
        paceText = "—"
        speedText = "—"
        gpsStatusText = nil
        hasGoodGpsFix = false
        workoutLocationManager.reset()
    }
    
    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
    
    private func updateElapsedText(session: WorkoutSession) {
        let endDate = session.status == .paused ? (session.pausedAt ?? Date()) : Date()
        let totalPaused = session.totalPausedSeconds
        let pausedOffset = session.status == .paused ? endDate.timeIntervalSince(session.pausedAt ?? endDate) : 0
        guard let startedAt = session.startedAt, session.status != .notStarted else {
            elapsedText = "00:00"
            return
        }
        let elapsed = max(endDate.timeIntervalSince(startedAt) - totalPaused - pausedOffset, 0)
        let displayDate = Date().addingTimeInterval(-elapsed)
        elapsedText = displayDate.elapsedText(to: Date())
    }
    
    private func updateMetrics() {
        let totalDistance = WorkoutRouteMetrics.totalDistance(points: routePoints) ?? 0
        distanceText = formatDistance(totalDistance)
        
        if let session = currentSession, let startedAt = session.startedAt, session.status != .notStarted {
            let endDate = session.status == .paused ? (session.pausedAt ?? Date()) : Date()
            let pausedOffset = session.status == .paused ? endDate.timeIntervalSince(session.pausedAt ?? endDate) : 0
            let elapsed = max(endDate.timeIntervalSince(startedAt) - session.totalPausedSeconds - pausedOffset, 0)
            paceText = formatPace(distanceMeters: totalDistance, elapsed: elapsed)
            speedText = formatSpeed(distanceMeters: totalDistance, elapsed: elapsed)
        } else {
            paceText = "—"
            speedText = "—"
        }
        
        splits = WorkoutSplitCalculator.splits(from: routePoints)
    }

    private func updateGpsStatus() {
        guard let accuracy = currentLocationPoint?.horizontalAccuracy else {
            gpsStatusText = "Waiting for GPS…"
            hasGoodGpsFix = false
            return
        }
        let rounded = accuracy.rounded()
        if accuracy <= gpsAccuracyThreshold {
            gpsStatusText = "GPS locked (\(Int(rounded)) m)"
            hasGoodGpsFix = true
        } else {
            gpsStatusText = "Waiting for GPS (\(Int(rounded)) m)"
            hasGoodGpsFix = false
        }
    }
    
    private func formatDistance(_ meters: Double) -> String {
        guard meters > 0 else { return "—" }
        let kilometers = meters / 1000
        return "\(kilometers.formatted(.number.precision(.fractionLength(2)))) km"
    }
    
    private func formatPace(distanceMeters: Double, elapsed: TimeInterval) -> String {
        guard distanceMeters > 0, elapsed > 0 else { return "—" }
        let pacePerKm = elapsed / (distanceMeters / 1000)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        let pace = formatter.string(from: pacePerKm) ?? "—"
        return "\(pace) /km"
    }
    
    private func formatSpeed(distanceMeters: Double, elapsed: TimeInterval) -> String {
        guard distanceMeters > 0, elapsed > 0 else { return "—" }
        let metersPerSecond = distanceMeters / elapsed
        let kmh = metersPerSecond * 3.6
        return "\(kmh.formatted(.number.precision(.fractionLength(1)))) km/h"
    }
}
