//
//  ExerciseMinutesDetailService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

public final class ExerciseMinutesDetailService: ExerciseMinutesDetailServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func requestAuthorization() async -> Bool {
        await healthKitAdapter.authorizationProvider.requestExerciseMinutesAuthorization()
    }

    public func updates(window: ExerciseMinutesWindow) -> AsyncStream<ExerciseMinutesDetailUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                let summary = await firstValue(from: healthKitAdapter.exerciseMinutesSummaryStream(days: window.days))
                let activitySummary = await firstValue(from: healthKitAdapter.activitySummaryStream(days: window.days))
                let latest = summary?.latest.map { [$0] } ?? []
                let previous = summary?.previous ?? []
                let activityLatest = activitySummary?.latest.map { [$0] } ?? []
                let activityPrevious = activitySummary?.previous ?? []
                let activityDays = activityLatest + activityPrevious
                let calendar = Calendar.current
                let activityByDate = Dictionary(grouping: activityDays, by: { calendar.startOfDay(for: $0.date) })

                let days = (latest + previous).map { day in
                    let key = calendar.startOfDay(for: day.date)
                    let goal = activityByDate[key]?.first?.exerciseGoal
                    return ExerciseMinutesDayDetail(date: day.date, minutes: day.minutes, goalMinutes: goal)
                }
                guard !Task.isCancelled else { return }
                continuation.yield(ExerciseMinutesDetailUpdate(days: days))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    private func firstValue<T>(from stream: AsyncStream<T>) async -> T? {
        for await value in stream {
            return value
        }
        return nil
    }
}
