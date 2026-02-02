//
//  CurrentWorkoutViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class CurrentWorkoutViewModel: ObservableObject {
    @Published public private(set) var currentSession: WorkoutSession?
    @Published public private(set) var errorMessage: String?
    @Published public private(set) var elapsedText: String?
    @Published public private(set) var routePoints: [WorkoutRoutePoint]
    @Published public private(set) var splits: [WorkoutSplit]
    @Published public private(set) var distanceText: String
    @Published public private(set) var paceText: String
    @Published public private(set) var speedText: String

    private let service: WorkoutFlowServiceProtocol
    private let locationService: LocationServiceProtocol
    private var task: Task<Void, Never>?
    private var locationTask: Task<Void, Never>?
    private var timerCancellable: AnyCancellable?

    public init(service: WorkoutFlowServiceProtocol, locationService: LocationServiceProtocol) {
        self.service = service
        self.locationService = locationService
        self.currentSession = nil
        self.errorMessage = nil
        self.elapsedText = nil
        self.routePoints = []
        self.splits = []
        self.distanceText = "—"
        self.paceText = "—"
        self.speedText = "—"
    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let service = self?.service else { return }
            for await update in service.updates() {
                guard let self, !Task.isCancelled else { break }
                self.currentSession = update.currentSession
                self.configureTimer(for: update.currentSession)
                self.configureLocationUpdates(for: update.currentSession)
            }
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
        locationTask?.cancel()
        locationTask = nil
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
        service.pauseWorkout()
    }

    public func resumeWorkout() {
        service.resumeWorkout()
    }

    public func beginWorkout() {
        service.beginWorkout()
    }

    public func clearError() {
        errorMessage = nil
    }

    public var isOutdoorSupported: Bool {
        guard let type = currentSession?.type else { return false }
        return type == .walking || type == .running || type == .cycling
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
            routePoints = []
            splits = []
            distanceText = "—"
            paceText = "—"
            speedText = "—"
            return
        }

        guard locationTask == nil else { return }
        locationTask = Task { [weak self] in
            guard let self else { return }
            for await point in locationService.locationUpdates() {
                guard !Task.isCancelled else { break }
                if self.currentSession?.status != .active { continue }
                self.routePoints.append(point)
                self.updateMetrics()
            }
        }
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
