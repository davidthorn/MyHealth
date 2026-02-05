//
//  TodayService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

@MainActor
public final class TodayService: TodayServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func updates() -> AsyncStream<TodayUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                continuation.yield(
                    TodayUpdate(
                        title: "Today",
                        latestWorkout: nil,
                        activityRingsDay: nil,
                        sleepDay: nil,
                        restingHeartRateSummary: nil,
                        heartRateVariabilitySummary: nil,
                        heartRateSummary: nil,
                        stepsSummary: nil,
                        caloriesSummary: nil,
                        exerciseMinutesSummary: nil,
                        standHoursSummary: nil,
                        hydrationMilliliters: nil
                    )
                )
                let activityAuthorized = await healthKitAdapter.authorizationProvider.requestActivitySummaryAuthorization()
                let workoutAuthorized = await healthKitAdapter.authorizationProvider.requestWorkoutAuthorization()
                let heartRateAuthorized = await healthKitAdapter.authorizationProvider.requestHeartRateAuthorization()
                let sleepAuthorized = await healthKitAdapter.authorizationProvider.requestSleepAnalysisAuthorization()
                let restingAuthorized = await healthKitAdapter.authorizationProvider.requestRestingHeartRateAuthorization()
                let hrvAuthorized = await healthKitAdapter.authorizationProvider.requestHeartRateVariabilityAuthorization()
                let stepsAuthorized = await healthKitAdapter.authorizationProvider.requestStepsAuthorization()
                let caloriesAuthorized = await healthKitAdapter.authorizationProvider.requestActiveEnergyAuthorization()
                let exerciseAuthorized = await healthKitAdapter.authorizationProvider.requestExerciseMinutesAuthorization()
                let standAuthorized = await healthKitAdapter.authorizationProvider.requestStandHoursAuthorization()
                let hydrationAuthorized = await healthKitAdapter.authorizationProvider.requestNutritionReadAuthorization(type: .water)
                guard !Task.isCancelled else {
                    continuation.finish()
                    return
                }

                let activitySummary = activityAuthorized
                    ? await firstValue(from: healthKitAdapter.activitySummaryStream(days: 14))
                    : nil
                let todaySummary = activityAuthorized
                    ? await healthKitAdapter.activitySummaryDay(date: Date())
                    : nil
                let activityDay = selectActivityDay(today: todaySummary, summary: activitySummary)

                let sleepSummary = sleepAuthorized
                    ? await firstValue(from: healthKitAdapter.sleepAnalysisSummaryStream(days: 7))
                    : nil
                let sleepDay = sleepSummary?.latest ?? sleepSummary?.previous.first

                let restingSummary = restingAuthorized
                    ? await firstValue(from: healthKitAdapter.restingHeartRateSummaryStream(days: 7))
                    : nil
                let hrvSummary = hrvAuthorized
                    ? await firstValue(from: healthKitAdapter.hrvProvider.summaryStream())
                    : nil
                let heartRateSummary = heartRateAuthorized
                    ? await firstValue(from: healthKitAdapter.heartRateSummaryStream())
                    : nil

                let stepsSummary = stepsAuthorized
                    ? await firstValue(from: healthKitAdapter.stepsSummaryStream(days: 1))
                    : nil
                let caloriesSummary = caloriesAuthorized
                    ? await firstValue(from: healthKitAdapter.activeEnergySummaryStream(days: 1))
                    : nil
                let exerciseSummary = exerciseAuthorized
                    ? await firstValue(from: healthKitAdapter.exerciseMinutesSummaryStream(days: 1))
                    : nil
                let standSummary = standAuthorized
                    ? await firstValue(from: healthKitAdapter.standHoursSummaryStream(days: 1))
                    : nil
                let hydrationTotal = hydrationAuthorized
                    ? await hydrationTotalForToday()
                    : nil

                let workouts = workoutAuthorized
                    ? (await firstValue(from: healthKitAdapter.workoutsStream()) ?? [])
                    : []
                let latestWorkout = workouts.first
                let latestSnapshot: TodayLatestWorkout?
                if let latestWorkout {
                    let routePoints = (try? await healthKitAdapter.workoutRoute(id: latestWorkout.id)) ?? []
                    let heartRateReadings = heartRateAuthorized
                        ? await healthKitAdapter.heartRateReadings(from: latestWorkout.startedAt, to: latestWorkout.endedAt)
                        : []
                    let heartRatePoints = WorkoutSplitCalculator.heartRateLinePoints(from: heartRateReadings)
                    latestSnapshot = TodayLatestWorkout(
                        workout: latestWorkout,
                        routePoints: routePoints,
                        heartRatePoints: heartRatePoints
                    )
                } else {
                    latestSnapshot = nil
                }

                guard !Task.isCancelled else {
                    continuation.finish()
                    return
                }
                continuation.yield(
                    TodayUpdate(
                        title: "Today",
                        latestWorkout: latestSnapshot,
                        activityRingsDay: activityDay,
                        sleepDay: sleepDay,
                        restingHeartRateSummary: restingSummary,
                        heartRateVariabilitySummary: hrvSummary,
                        heartRateSummary: heartRateSummary,
                        stepsSummary: stepsSummary,
                        caloriesSummary: caloriesSummary,
                        exerciseMinutesSummary: exerciseSummary,
                        standHoursSummary: standSummary,
                        hydrationMilliliters: hydrationTotal
                    )
                )
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

    private func selectActivityDay(
        today: ActivityRingsDay?,
        summary: ActivityRingsSummary?
    ) -> ActivityRingsDay? {
        if let today {
            return today
        }
        return summary?.latest ?? summary?.previous.first
    }

    private func hydrationTotalForToday() async -> Double? {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date())
        guard let end = calendar.date(byAdding: .day, value: 1, to: start) else { return nil }
        return await healthKitAdapter.nutritionTotal(type: .water, start: start, end: end)
    }
}
