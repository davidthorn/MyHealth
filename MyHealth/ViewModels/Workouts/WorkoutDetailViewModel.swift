//
//  WorkoutDetailViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
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
                WorkoutSplitCalculator.splits(from: points)
            }.value
            guard !Task.isCancelled else { return }
            self?.splits = splits
            self?.loadSplitHeartRates()
        }
    }

    public func splitDurationText(_ split: WorkoutSplit) -> String {
        split.formattedDurationText
    }

    public func paceText(_ split: WorkoutSplit) -> String {
        split.formattedPaceText
    }

    public func heartRateText(_ split: WorkoutSplit) -> String? {
        split.formattedHeartRateText
    }

    private func loadSplitHeartRates() {
        guard let start = splits.first?.startDate,
              let end = splits.last?.endDate
        else { return }

        heartRateTask?.cancel()
        let splitRanges = splits
        heartRateTask = Task { [weak self] in
            guard let service = self?.service else { return }
            for await readings in service.heartRateUpdates(start: start, end: end) {
                guard let self, !Task.isCancelled else { break }
                let updated = WorkoutSplitCalculator.applyAverageHeartRates(readings, to: splitRanges)
                self.splits = updated
                self.workoutHeartRatePoints = WorkoutSplitCalculator.heartRateLinePoints(from: readings)
            }
        }
    }
}
