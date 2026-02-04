//
//  InsightsService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

@MainActor
public final class InsightsService: InsightsServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func requestAuthorization() async -> Bool {
        let activity = await healthKitAdapter.authorizationProvider.requestActivitySummaryAuthorization()
        let workouts = await healthKitAdapter.authorizationProvider.requestWorkoutAuthorization()
        let heartRate = await healthKitAdapter.authorizationProvider.requestHeartRateAuthorization()
        let resting = await healthKitAdapter.authorizationProvider.requestRestingHeartRateAuthorization()
        let hrv = await healthKitAdapter.authorizationProvider.requestHeartRateVariabilityAuthorization()
        return activity || workouts || heartRate || resting || hrv
    }

    public func updates() -> AsyncStream<InsightsUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                continuation.yield(InsightsUpdate(title: "Insights", isAuthorized: false, insights: []))

                let activityAuthorized = await healthKitAdapter.authorizationProvider.requestActivitySummaryAuthorization()
                let workoutsAuthorized = await healthKitAdapter.authorizationProvider.requestWorkoutAuthorization()
                let heartRateAuthorized = await healthKitAdapter.authorizationProvider.requestHeartRateAuthorization()
                let restingAuthorized = await healthKitAdapter.authorizationProvider.requestRestingHeartRateAuthorization()
                let hrvAuthorized = await healthKitAdapter.authorizationProvider.requestHeartRateVariabilityAuthorization()
                let isAuthorized = activityAuthorized || workoutsAuthorized || heartRateAuthorized || restingAuthorized || hrvAuthorized
                guard !Task.isCancelled else { return }
                guard isAuthorized else {
                    continuation.yield(InsightsUpdate(title: "Insights", isAuthorized: false, insights: []))
                    continuation.finish()
                    return
                }

                var insights: [InsightItem] = []

                if activityAuthorized {
                    let summary = await firstValue(from: healthKitAdapter.activitySummaryStream(days: 7))
                    guard !Task.isCancelled else { return }
                    insights.append(contentsOf: buildActivityInsights(from: summary))
                }

                if workoutsAuthorized {
                    let workouts = await firstValue(from: healthKitAdapter.workoutsStream()) ?? []
                    guard !Task.isCancelled else { return }
                    let workoutInsight = await buildWorkoutInsights(from: workouts, includeHeartRate: heartRateAuthorized)
                    if let workoutInsight {
                        insights.append(workoutInsight)
                    }
                }

                if restingAuthorized || hrvAuthorized {
                    let recoveryInsight = await buildRecoveryReadinessInsights(
                        includeResting: restingAuthorized,
                        includeHrv: hrvAuthorized
                    )
                    if let recoveryInsight {
                        insights.append(recoveryInsight)
                    }
                }

                continuation.yield(InsightsUpdate(title: "Insights", isAuthorized: true, insights: insights))
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

    private func buildActivityInsights(from summary: ActivityRingsSummary?) -> [InsightItem] {
        guard let summary else { return [] }
        var days: [ActivityRingsDay] = []
        if let latest = summary.latest {
            days.append(latest)
        }
        days.append(contentsOf: summary.previous)

        let sortedDays = days.sorted { $0.date > $1.date }
        let recentDays = Array(sortedDays.prefix(7))
        let previousDays = Array(sortedDays.dropFirst(7).prefix(7))
        guard !recentDays.isEmpty else { return [] }

        let totalDays = recentDays.count
        let totalMove = recentDays.map(\.moveValue).reduce(0, +)
        let totalExercise = recentDays.map(\.exerciseMinutes).reduce(0, +)
        let totalStand = recentDays.map(\.standHours).reduce(0, +)
        let activeDays = recentDays.filter { $0.exerciseMinutes > 0 }.count
        let daysWithRingClosed = recentDays.filter { $0.closedRingsCount > 0 }.count

        let bestDay = recentDays.max { $0.moveValue < $1.moveValue }
        let bestDayMove = bestDay?.moveValue ?? 0
        let worstDay = recentDays.min { $0.moveValue < $1.moveValue }
        let worstDayMove = worstDay?.moveValue ?? 0

        let averageMove = totalMove / Double(totalDays)
        let averageExercise = totalExercise / Double(totalDays)
        let averageStand = totalStand / Double(totalDays)
        let averageMoveGoal = averageGoal(for: recentDays, metric: .move)
        let averageExerciseGoal = averageGoal(for: recentDays, metric: .exercise)
        let averageStandGoal = averageGoal(for: recentDays, metric: .stand)

        let summaryText = "Move \(formatNumber(totalMove)) kcal • Exercise \(formatNumber(totalExercise)) min"
        let detailText = "Active \(activeDays)/\(totalDays) days • Stand \(formatNumber(totalStand)) stand hrs"
        let statusText = activeDays >= 5 ? "Strong" : (activeDays >= 3 ? "Steady" : "Fresh Start")

        return [
            InsightItem(
                type: .activityHighlights,
                title: InsightType.activityHighlights.title,
                summary: summaryText,
                detail: detailText,
                status: statusText,
                icon: "figure.walk",
                activityHighlights: ActivityHighlightsInsight(
                    recentDays: recentDays,
                    previousDays: previousDays,
                    totalMove: totalMove,
                    totalExerciseMinutes: totalExercise,
                    totalStandHours: totalStand,
                    activeDays: activeDays,
                    daysWithRingClosed: daysWithRingClosed,
                    bestDayDate: bestDay?.date,
                    bestDayMove: bestDayMove,
                    worstDayDate: worstDay?.date,
                    worstDayMove: worstDayMove,
                    averageMove: averageMove,
                    averageExercise: averageExercise,
                    averageStand: averageStand,
                    averageMoveGoal: averageMoveGoal,
                    averageExerciseGoal: averageExerciseGoal,
                    averageStandGoal: averageStandGoal
                )
            )
        ]
    }

    private func buildWorkoutInsights(
        from workouts: [Workout],
        includeHeartRate: Bool
    ) async -> InsightItem? {
        let calendar = Calendar.current
        let windowEnd = Date()
        guard let windowStart = calendar.date(byAdding: .day, value: -7, to: windowEnd) else { return nil }

        let recentWorkouts = workouts.filter { $0.startedAt >= windowStart && $0.startedAt <= windowEnd }
            .sorted { $0.startedAt > $1.startedAt }

        guard !recentWorkouts.isEmpty else { return nil }

        var summaries: [WorkoutInsightSummary] = []
        summaries.reserveCapacity(recentWorkouts.count)

        var allHeartRates: [HeartRateReading] = []

        for workout in recentWorkouts {
            guard !Task.isCancelled else { return nil }
            let durationSeconds = workout.durationSeconds ?? workout.endedAt.timeIntervalSince(workout.startedAt)
            let durationMinutes = max(0, durationSeconds / 60)

            var averageHeartRate: Double?
            var peakHeartRate: Double?

            if includeHeartRate {
                let readings = await healthKitAdapter.heartRateReadings(from: workout.startedAt, to: workout.endedAt)
                allHeartRates.append(contentsOf: readings)
                if let average = WorkoutRouteMetrics.averageHeartRate(readings: readings) {
                    averageHeartRate = average
                }
                peakHeartRate = readings.map(\.bpm).max()
            }

            summaries.append(
                WorkoutInsightSummary(
                    id: workout.id,
                    type: workout.type,
                    startedAt: workout.startedAt,
                    durationMinutes: durationMinutes,
                    distanceMeters: workout.totalDistanceMeters,
                    averageHeartRate: averageHeartRate,
                    peakHeartRate: peakHeartRate
                )
            )
        }

        let totalDurationMinutes = summaries.map(\.durationMinutes).reduce(0, +)
        let totalDistanceMeters = totalDistance(recentWorkouts)
        let averageHeartRate = WorkoutRouteMetrics.averageHeartRate(readings: allHeartRates)
        let peakHeartRate = allHeartRates.map(\.bpm).max()

        let mostIntense = summaries
            .sorted { (lhs, rhs) -> Bool in
                let lhsValue = lhs.averageHeartRate ?? lhs.peakHeartRate ?? 0
                let rhsValue = rhs.averageHeartRate ?? rhs.peakHeartRate ?? 0
                return lhsValue > rhsValue
            }
            .first

        let longest = summaries.max { $0.durationMinutes < $1.durationMinutes }

        let summaryText = "\(summaries.count) workouts • \(formatNumber(totalDurationMinutes)) min"
        let detailText = buildWorkoutDetailText(averageHeartRate: averageHeartRate, peakHeartRate: peakHeartRate)
        let statusText = summaries.count >= 4 ? "Strong" : (summaries.count >= 2 ? "Building" : "Starting")

        return InsightItem(
            type: .workoutHighlights,
            title: InsightType.workoutHighlights.title,
            summary: summaryText,
            detail: detailText,
            status: statusText,
            icon: "figure.run",
            workoutHighlights: WorkoutHighlightsInsight(
                windowStart: windowStart,
                windowEnd: windowEnd,
                workoutCount: summaries.count,
                totalDurationMinutes: totalDurationMinutes,
                totalDistanceMeters: totalDistanceMeters,
                averageHeartRate: averageHeartRate,
                peakHeartRate: peakHeartRate,
                mostIntenseWorkout: mostIntense,
                longestWorkout: longest,
                recentWorkouts: Array(summaries.prefix(6))
            )
        )
    }

    private func buildWorkoutDetailText(averageHeartRate: Double?, peakHeartRate: Double?) -> String {
        var parts: [String] = []
        if let averageHeartRate {
            parts.append("Avg HR \(formatNumber(averageHeartRate)) bpm")
        }
        if let peakHeartRate {
            parts.append("Peak \(formatNumber(peakHeartRate)) bpm")
        }
        return parts.isEmpty ? "Heart rate data unavailable" : parts.joined(separator: " • ")
    }

    private func buildRecoveryReadinessInsights(
        includeResting: Bool,
        includeHrv: Bool
    ) async -> InsightItem? {
        guard includeResting || includeHrv else { return nil }

        let windowEnd = Date()
        let calendar = Calendar.current
        guard let windowStart = calendar.date(byAdding: .day, value: -14, to: windowEnd) else { return nil }

        var restingDays: [RestingHeartRateDay] = []
        if includeResting {
            let summary = await firstValue(from: healthKitAdapter.restingHeartRateSummaryStream(days: 14))
            if let summary {
                if let latest = summary.latest {
                    restingDays.append(latest)
                }
                restingDays.append(contentsOf: summary.previous)
            }
        }

        let hrvDays = includeHrv ? await healthKitAdapter.hrvProvider.dailyStats(days: 14) : []

        guard !restingDays.isEmpty || !hrvDays.isEmpty else { return nil }

        let latestResting = restingDays.sorted { $0.date > $1.date }.first?.averageBpm
        let latestHrv = hrvDays.sorted { $0.date > $1.date }.first?.averageMilliseconds

        let restingTrend = trend(
            current: averageForLast7Days(restingDays.map { ($0.date, $0.averageBpm) }),
            previous: averageForPrevious7Days(restingDays.map { ($0.date, $0.averageBpm) }),
            threshold: 1.0
        )

        let hrvTrend = trend(
            current: averageForLast7Days(hrvDays.compactMap { day in
                guard let value = day.averageMilliseconds else { return nil }
                return (day.date, value)
            }),
            previous: averageForPrevious7Days(hrvDays.compactMap { day in
                guard let value = day.averageMilliseconds else { return nil }
                return (day.date, value)
            }),
            threshold: 2.0
        )

        let currentRestingAverage = averageForLast7Days(restingDays.map { ($0.date, $0.averageBpm) })
        let previousRestingAverage = averageForPrevious7Days(restingDays.map { ($0.date, $0.averageBpm) })
        let currentHrvAverage = averageForLast7Days(hrvDays.compactMap { day in
            guard let value = day.averageMilliseconds else { return nil }
            return (day.date, value)
        })
        let previousHrvAverage = averageForPrevious7Days(hrvDays.compactMap { day in
            guard let value = day.averageMilliseconds else { return nil }
            return (day.date, value)
        })

        let status = recoveryStatus(restingTrend: restingTrend, hrvTrend: hrvTrend)

        let summaryText = recoverySummaryText(latestResting: latestResting, latestHrv: latestHrv)
        let detailText = recoveryDetailText(restingTrend: restingTrend, hrvTrend: hrvTrend)

        return InsightItem(
            type: .recoveryReadiness,
            title: InsightType.recoveryReadiness.title,
            summary: summaryText,
            detail: detailText,
            status: status.title,
            icon: "heart.circle",
            recoveryReadiness: RecoveryReadinessInsight(
                windowStart: windowStart,
                windowEnd: windowEnd,
                latestRestingBpm: latestResting,
                latestHrvMilliseconds: latestHrv,
                currentRestingAverage: currentRestingAverage,
                previousRestingAverage: previousRestingAverage,
                currentHrvAverage: currentHrvAverage,
                previousHrvAverage: previousHrvAverage,
                restingTrend: restingTrend,
                hrvTrend: hrvTrend,
                status: status
            )
        )
    }

    private func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "\(Int(value.rounded()))"
    }

    private func totalDistance(_ workouts: [Workout]) -> Double? {
        let values = workouts.compactMap(\.totalDistanceMeters)
        guard !values.isEmpty else { return nil }
        return values.reduce(0, +)
    }

    private func averageForLast7Days(_ values: [(Date, Double)]) -> Double? {
        let calendar = Calendar.current
        let windowEnd = Date()
        guard let windowStart = calendar.date(byAdding: .day, value: -7, to: windowEnd) else { return nil }
        let filtered = values.filter { $0.0 >= windowStart && $0.0 <= windowEnd }
        guard !filtered.isEmpty else { return nil }
        return filtered.map(\.1).reduce(0, +) / Double(filtered.count)
    }

    private func averageForPrevious7Days(_ values: [(Date, Double)]) -> Double? {
        let calendar = Calendar.current
        let windowEnd = Date()
        guard let windowStart = calendar.date(byAdding: .day, value: -14, to: windowEnd),
              let windowMid = calendar.date(byAdding: .day, value: -7, to: windowEnd) else { return nil }
        let filtered = values.filter { $0.0 >= windowStart && $0.0 < windowMid }
        guard !filtered.isEmpty else { return nil }
        return filtered.map(\.1).reduce(0, +) / Double(filtered.count)
    }

    private func trend(
        current: Double?,
        previous: Double?,
        threshold: Double
    ) -> RecoveryReadinessTrend {
        guard let current, let previous else { return .unknown }
        let delta = current - previous
        if delta > threshold {
            return .up
        }
        if delta < -threshold {
            return .down
        }
        return .steady
    }

    private func recoveryStatus(
        restingTrend: RecoveryReadinessTrend,
        hrvTrend: RecoveryReadinessTrend
    ) -> RecoveryReadinessStatus {
        switch (restingTrend, hrvTrend) {
        case (.down, .up):
            return .ready
        case (.up, .down):
            return .strained
        case (.unknown, _), (_, .unknown):
            return .unclear
        default:
            return .steady
        }
    }

    private func recoverySummaryText(latestResting: Double?, latestHrv: Double?) -> String {
        var parts: [String] = []
        if let latestResting {
            parts.append("RHR \(formatNumber(latestResting)) bpm")
        }
        if let latestHrv {
            parts.append("HRV \(formatNumber(latestHrv)) ms")
        }
        return parts.isEmpty ? "Recovery data unavailable" : parts.joined(separator: " • ")
    }

    private func recoveryDetailText(
        restingTrend: RecoveryReadinessTrend,
        hrvTrend: RecoveryReadinessTrend
    ) -> String {
        "7-day trend: RHR \(restingTrend.label) • HRV \(hrvTrend.label)"
    }

    private func averageGoal(for days: [ActivityRingsDay], metric: ActivityRingsMetric) -> Double {
        guard !days.isEmpty else { return 0 }
        let values = days.compactMap { day -> Double? in
            switch metric {
            case .move:
                guard day.moveGoal > 0 else { return nil }
                return day.moveGoal
            case .exercise:
                guard day.exerciseGoal > 0 else { return nil }
                return day.exerciseGoal
            case .stand:
                guard day.standGoal > 0 else { return nil }
                return day.standGoal
            }
        }
        guard !values.isEmpty else { return 0 }
        return values.reduce(0, +) / Double(values.count)
    }
}
