//
//  WorkoutDetailViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import CoreLocation
import Foundation
import Models

@MainActor
public final class WorkoutDetailViewModel: ObservableObject {
    @Published public private(set) var workout: Workout?
    @Published public private(set) var routePoints: [WorkoutRoutePoint]
    @Published public private(set) var splits: [WorkoutSplit]
    @Published public private(set) var workoutHeartRatePoints: [HeartRateRangePoint]
    @Published public var isDeleteAlertPresented: Bool
    @Published public var errorMessage: String?

    private let service: WorkoutDetailServiceProtocol
    private let id: UUID
    private var task: Task<Void, Never>?
    private var routeTask: Task<Void, Never>?
    private var splitsTask: Task<Void, Never>?
    private var heartRateTask: Task<Void, Never>?

    public init(service: WorkoutDetailServiceProtocol, id: UUID) {
        self.service = service
        self.id = id
        self.workout = nil
        self.routePoints = []
        self.splits = []
        self.workoutHeartRatePoints = []
        self.isDeleteAlertPresented = false
        self.errorMessage = nil
    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let self else { return }
            let service = self.service
            for await update in service.updates(for: id) {
                guard !Task.isCancelled else { break }
                self.workout = update
            }
        }
        startRouteUpdates()
    }

    public func stop() {
        task?.cancel()
        task = nil
        routeTask?.cancel()
        routeTask = nil
        splitsTask?.cancel()
        splitsTask = nil
        heartRateTask?.cancel()
        heartRateTask = nil
    }

    public func requestDelete() {
        isDeleteAlertPresented = true
    }

    public func delete() async -> Bool {
        do {
            try await service.delete(id: id)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    public var durationText: String? {
        guard let workout else { return nil }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: workout.startedAt, to: workout.endedAt)
    }

    private func startRouteUpdates() {
        guard routeTask == nil else { return }
        let workoutId = id
        routeTask = Task { [weak self] in
            guard let service = self?.service else { return }
            for await points in service.routeUpdates(for: workoutId) {
                guard let self, !Task.isCancelled else { break }
                self.routePoints = points
                self.computeSplits()
            }
        }
    }

    private func computeSplits() {
        splitsTask?.cancel()
        let points = routePoints
        splitsTask = Task { [weak self] in
            let splits = await Task.detached {
                Self.calculateSplits(points: points)
            }.value
            guard !Task.isCancelled else { return }
            self?.splits = splits
            self?.loadSplitHeartRates()
        }
    }

    private nonisolated static func calculateSplits(points: [WorkoutRoutePoint]) -> [WorkoutSplit] {
        let sortedPoints = points.sorted { $0.timestamp < $1.timestamp }
        guard sortedPoints.count >= 2 else { return [] }

        let startDate = sortedPoints[0].timestamp
        var splits: [WorkoutSplit] = []
        var lastSplitElapsed: TimeInterval = 0
        var cumulativeDistance: Double = 0
        var cumulativeTime: TimeInterval = 0
        var nextSplitDistance: Double = 1000
        var splitIndex = 1

        var previous = sortedPoints[0]
        for point in sortedPoints.dropFirst() {
            let startLocation = CLLocation(latitude: previous.latitude, longitude: previous.longitude)
            let endLocation = CLLocation(latitude: point.latitude, longitude: point.longitude)
            var segmentDistance = endLocation.distance(from: startLocation)
            var segmentTime = point.timestamp.timeIntervalSince(previous.timestamp)

            if segmentDistance <= 0 || segmentTime <= 0 {
                previous = point
                continue
            }

            while cumulativeDistance + segmentDistance >= nextSplitDistance {
                let remaining = nextSplitDistance - cumulativeDistance
                let ratio = remaining / segmentDistance
                let timeAtSplitElapsed = cumulativeTime + segmentTime * ratio
                let splitDuration = timeAtSplitElapsed - lastSplitElapsed
                let pace = splitDuration
                let splitStart = startDate.addingTimeInterval(lastSplitElapsed)
                let splitEnd = startDate.addingTimeInterval(timeAtSplitElapsed)

                splits.append(
                    WorkoutSplit(
                        index: splitIndex,
                        distanceMeters: 1000,
                        durationSeconds: splitDuration,
                        paceSecondsPerKilometer: pace,
                        startDate: splitStart,
                        endDate: splitEnd
                    )
                )

                splitIndex += 1
                lastSplitElapsed = timeAtSplitElapsed

                segmentDistance -= remaining
                segmentTime -= segmentTime * ratio
                cumulativeDistance = nextSplitDistance
                cumulativeTime = timeAtSplitElapsed
                nextSplitDistance += 1000

                if segmentDistance <= 0 || segmentTime <= 0 { break }
            }

            cumulativeDistance += segmentDistance
            cumulativeTime += segmentTime
            previous = point
        }

        let completedDistance = Double(splitIndex - 1) * 1000
        let remainingDistance = max(cumulativeDistance - completedDistance, 0)
        if remainingDistance > 0, let lastPoint = sortedPoints.last {
            let splitStart = startDate.addingTimeInterval(lastSplitElapsed)
            let splitEnd = lastPoint.timestamp
            let splitDuration = splitEnd.timeIntervalSince(splitStart)
            let pace = splitDuration / (remainingDistance / 1000)
            splits.append(
                WorkoutSplit(
                    index: splitIndex,
                    distanceMeters: remainingDistance,
                    durationSeconds: splitDuration,
                    paceSecondsPerKilometer: pace,
                    startDate: splitStart,
                    endDate: splitEnd
                )
            )
        }

        return splits
    }

    public func splitDurationText(_ split: WorkoutSplit) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: split.durationSeconds) ?? "—"
    }

    public func paceText(_ split: WorkoutSplit) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        let pace = formatter.string(from: split.paceSecondsPerKilometer) ?? "—"
        return "\(pace) /km"
    }

    public func heartRateText(_ split: WorkoutSplit) -> String? {
        guard let average = split.averageHeartRateBpm else { return nil }
        return "\(Int(average.rounded())) bpm"
    }

    private func loadSplitHeartRates() {
        guard let start = splits.first?.startDate,
              let end = splits.last?.endDate
        else { return }

        heartRateTask?.cancel()
        let splitRanges = splits.map { (id: $0.id, start: $0.startDate, end: $0.endDate) }
        heartRateTask = Task { [weak self] in
            guard let service = self?.service else { return }
            for await readings in service.heartRateUpdates(start: start, end: end) {
                guard let self, !Task.isCancelled else { break }
                let updated = self.applyHeartRates(readings, to: splitRanges)
                self.splits = updated
                self.workoutHeartRatePoints = Self.buildHeartRateLinePoints(from: readings)
            }
        }
    }

    private func applyHeartRates(
        _ readings: [HeartRateReading],
        to splitRanges: [(id: UUID, start: Date, end: Date)]
    ) -> [WorkoutSplit] {
        let readingsBySplit = splitRanges.map { range -> (UUID, Double?) in
            let samples = readings.filter { sample in
                sample.endDate >= range.start && sample.startDate <= range.end
            }
            guard !samples.isEmpty else { return (range.id, nil) }
            let average = samples.map(\.bpm).reduce(0, +) / Double(samples.count)
            return (range.id, average)
        }
        var averageMap: [UUID: Double] = [:]
        for (id, value) in readingsBySplit {
            if let value { averageMap[id] = value }
        }
        return splits.map { split in
            WorkoutSplit(
                id: split.id,
                index: split.index,
                distanceMeters: split.distanceMeters,
                durationSeconds: split.durationSeconds,
                paceSecondsPerKilometer: split.paceSecondsPerKilometer,
                startDate: split.startDate,
                endDate: split.endDate,
                averageHeartRateBpm: averageMap[split.id]
            )
        }
    }

    private nonisolated static func buildHeartRateLinePoints(from readings: [HeartRateReading]) -> [HeartRateRangePoint] {
        guard !readings.isEmpty else { return [] }
        let sorted = readings.sorted { $0.date < $1.date }
        return sorted.map { reading in
            HeartRateRangePoint(date: reading.date, bpm: reading.bpm)
        }
    }
}
