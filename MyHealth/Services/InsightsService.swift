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
        let cardio = await healthKitAdapter.authorizationProvider.requestCardioFitnessAuthorization()
        let sleep = await healthKitAdapter.authorizationProvider.requestSleepAnalysisAuthorization()
        return activity || workouts || heartRate || resting || hrv || cardio || sleep
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
                let cardioFitnessAuthorized = await healthKitAdapter.authorizationProvider.requestCardioFitnessAuthorization()
                let sleepAuthorized = await healthKitAdapter.authorizationProvider.requestSleepAnalysisAuthorization()
                let isAuthorized = activityAuthorized || workoutsAuthorized || heartRateAuthorized || restingAuthorized || hrvAuthorized || cardioFitnessAuthorized || sleepAuthorized
                guard !Task.isCancelled else { return }
                guard isAuthorized else {
                    continuation.yield(InsightsUpdate(title: "Insights", isAuthorized: false, insights: []))
                    continuation.finish()
                    return
                }

                var insights: [InsightItem] = []
                var workoutsCache: [Workout] = []
                var sleepDaysCache: [SleepDay] = []

                if activityAuthorized {
                    let summary = await firstValue(from: healthKitAdapter.activitySummaryStream(days: 7))
                    guard !Task.isCancelled else { return }
                    insights.append(contentsOf: buildActivityInsights(from: summary))
                }

                if workoutsAuthorized {
                    let workouts = await firstValue(from: healthKitAdapter.workoutsStream()) ?? []
                    workoutsCache = workouts
                    guard !Task.isCancelled else { return }
                    let workoutInsight = await buildWorkoutInsights(from: workouts, includeHeartRate: heartRateAuthorized)
                    if let workoutInsight {
                        insights.append(workoutInsight)
                    }

                    let loadInsight = await buildWorkoutLoadTrendInsights(
                        from: workouts,
                        includeHeartRate: heartRateAuthorized
                    )
                    if let loadInsight {
                        insights.append(loadInsight)
                    }

                    let intensityInsight = await buildWorkoutIntensityDistributionInsights(
                        from: workouts,
                        includeHeartRate: heartRateAuthorized
                    )
                    if let intensityInsight {
                        insights.append(intensityInsight)
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

                if workoutsAuthorized, (restingAuthorized || hrvAuthorized), !workoutsCache.isEmpty {
                    let balanceInsight = await buildWorkoutRecoveryBalanceInsights(
                        from: workoutsCache,
                        includeHeartRate: heartRateAuthorized,
                        includeResting: restingAuthorized,
                        includeHrv: hrvAuthorized
                    )
                    if let balanceInsight {
                        insights.append(balanceInsight)
                    }
                }

                if cardioFitnessAuthorized {
                    let cardioInsight = await buildCardioFitnessTrendInsight()
                    if let cardioInsight {
                        insights.append(cardioInsight)
                    }
                }

                if sleepAuthorized {
                    let sleepSummary = await firstValue(from: healthKitAdapter.sleepAnalysisSummaryStream(days: 14))
                    if let sleepSummary {
                        if let latest = sleepSummary.latest {
                            sleepDaysCache.append(latest)
                        }
                        sleepDaysCache.append(contentsOf: sleepSummary.previous)
                    }
                }

                if sleepAuthorized, workoutsAuthorized, !sleepDaysCache.isEmpty {
                    let sleepBalance = buildSleepTrainingBalanceInsights(
                        sleepDays: sleepDaysCache,
                        workouts: workoutsCache
                    )
                    if let sleepBalance {
                        insights.append(sleepBalance)
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
        let builder = ActivityInsightBuilder(summary: summary, windowDays: 7)
        guard let insight = builder.build() else { return [] }

        let totalDays = insight.recentDays.count
        let summaryText = "Move \(formatNumber(insight.totalMove)) kcal • Exercise \(formatNumber(insight.totalExerciseMinutes)) min"
        let detailText = "Active \(insight.activeDays)/\(totalDays) days • Stand \(formatNumber(insight.totalStandHours)) stand hrs"
        let statusText = insight.activeDays >= 5 ? "Strong" : (insight.activeDays >= 3 ? "Steady" : "Fresh Start")

        return [
            InsightItem(
                type: .activityHighlights,
                title: InsightType.activityHighlights.title,
                summary: summaryText,
                detail: detailText,
                status: statusText,
                icon: "figure.walk",
                activityHighlights: insight
            )
        ]
    }

    private func buildWorkoutInsights(
        from workouts: [Workout],
        includeHeartRate: Bool
    ) async -> InsightItem? {
        let builder = WorkoutInsightBuilder(
            healthKitAdapter: healthKitAdapter,
            workouts: workouts,
            includeHeartRate: includeHeartRate
        )
        guard let insight = await builder.build() else { return nil }

        let summaryText = "\(insight.workoutCount) workouts • \(formatNumber(insight.totalDurationMinutes)) min"
        let detailText = buildWorkoutDetailText(
            averageHeartRate: insight.averageHeartRate,
            peakHeartRate: insight.peakHeartRate
        )
        let statusText = insight.workoutCount >= 4 ? "Strong" : (insight.workoutCount >= 2 ? "Building" : "Starting")

        return InsightItem(
            type: .workoutHighlights,
            title: InsightType.workoutHighlights.title,
            summary: summaryText,
            detail: detailText,
            status: statusText,
            icon: "figure.run",
            workoutHighlights: insight
        )
    }

    private func buildWorkoutLoadTrendInsights(
        from workouts: [Workout],
        includeHeartRate: Bool
    ) async -> InsightItem? {
        let builder = WorkoutLoadTrendInsightBuilder(
            healthKitAdapter: healthKitAdapter,
            workouts: workouts,
            includeHeartRate: includeHeartRate
        )
        guard let insight = await builder.build() else { return nil }

        let summaryText = "This week \(formatNumber(insight.currentMinutes)) min • Last week \(formatNumber(insight.previousMinutes)) min"
        let detailText = loadDetailText(
            currentLoad: insight.currentLoad,
            previousLoad: insight.previousLoad
        )

        return InsightItem(
            type: .workoutLoadTrend,
            title: InsightType.workoutLoadTrend.title,
            summary: summaryText,
            detail: detailText,
            status: insight.status.title,
            icon: "chart.line.uptrend.xyaxis",
            workoutLoadTrend: insight
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
        let builder = RecoveryReadinessInsightBuilder(
            healthKitAdapter: healthKitAdapter,
            includeResting: includeResting,
            includeHrv: includeHrv
        )
        guard let insight = await builder.build() else { return nil }

        let summaryText = recoverySummaryText(
            latestResting: insight.latestRestingBpm,
            latestHrv: insight.latestHrvMilliseconds
        )
        let detailText = recoveryDetailText(
            restingTrend: insight.restingTrend,
            hrvTrend: insight.hrvTrend
        )

        return InsightItem(
            type: .recoveryReadiness,
            title: InsightType.recoveryReadiness.title,
            summary: summaryText,
            detail: detailText,
            status: insight.status.title,
            icon: "heart.circle",
            recoveryReadiness: insight
        )
    }

    private func buildWorkoutRecoveryBalanceInsights(
        from workouts: [Workout],
        includeHeartRate: Bool,
        includeResting: Bool,
        includeHrv: Bool
    ) async -> InsightItem? {
        let builder = WorkoutRecoveryBalanceInsightBuilder(
            healthKitAdapter: healthKitAdapter,
            workouts: workouts,
            includeHeartRate: includeHeartRate,
            includeResting: includeResting,
            includeHrv: includeHrv
        )
        guard let insight = await builder.build() else { return nil }

        let summaryText = buildRecoveryBalanceSummary(insight: insight)
        let detailText = buildRecoveryBalanceDetail(insight: insight)

        return InsightItem(
            type: .workoutRecoveryBalance,
            title: InsightType.workoutRecoveryBalance.title,
            summary: summaryText,
            detail: detailText,
            status: insight.status.title,
            icon: "bolt.heart",
            workoutRecoveryBalance: insight
        )
    }

    private func buildWorkoutIntensityDistributionInsights(
        from workouts: [Workout],
        includeHeartRate: Bool
    ) async -> InsightItem? {
        let builder = WorkoutIntensityDistributionInsightBuilder(
            healthKitAdapter: healthKitAdapter,
            workouts: workouts,
            includeHeartRate: includeHeartRate
        )
        guard let insight = await builder.build() else { return nil }

        let totalMinutes = insight.lowMinutes + insight.moderateMinutes + insight.highMinutes
        let totalText = totalMinutes > 0 ? "\(formatNumber(totalMinutes)) min" : "—"
        let summaryText = "\(totalText) • \(insight.workoutCount) workouts"
        let detailText = intensityDetailText(insight: insight)

        return InsightItem(
            type: .workoutIntensityDistribution,
            title: InsightType.workoutIntensityDistribution.title,
            summary: summaryText,
            detail: detailText,
            status: insight.status.title,
            icon: "speedometer",
            workoutIntensityDistribution: insight
        )
    }

    private func buildCardioFitnessTrendInsight() async -> InsightItem? {
        let builder = CardioFitnessTrendInsightBuilder(healthKitAdapter: healthKitAdapter)
        guard let insight = await builder.build() else { return nil }

        let latestText = insight.latestReading.map { "\(formatNumber($0.vo2Max)) ml/kg/min" } ?? "—"
        let averageText = insight.currentAverage.map { "\(formatNumber($0)) avg" } ?? "No average"
        let summaryText = "Latest \(latestText) • \(averageText)"
        let detailText = trendDetailText(current: insight.currentAverage, previous: insight.previousAverage)

        return InsightItem(
            type: .cardioFitnessTrend,
            title: InsightType.cardioFitnessTrend.title,
            summary: summaryText,
            detail: detailText,
            status: insight.status.title,
            icon: "wind",
            cardioFitnessTrend: insight
        )
    }

    private func buildSleepTrainingBalanceInsights(
        sleepDays: [SleepDay],
        workouts: [Workout]
    ) -> InsightItem? {
        let builder = SleepTrainingBalanceInsightBuilder(workouts: workouts, sleepDays: sleepDays)
        guard let insight = builder.build() else { return nil }

        let sleepText = insight.currentSleepHours.map { "\(formatNumber($0)) hr avg" } ?? "Sleep unavailable"
        let loadText = insight.currentLoadMinutes.map { "\(formatNumber($0)) min load" } ?? "Load unavailable"
        let summaryText = "\(sleepText) • \(loadText)"
        let detailText = sleepBalanceDetail(insight: insight)

        return InsightItem(
            type: .sleepTrainingBalance,
            title: InsightType.sleepTrainingBalance.title,
            summary: summaryText,
            detail: detailText,
            status: insight.status.title,
            icon: "bed.double.fill",
            sleepTrainingBalance: insight
        )
    }

    private func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "\(Int(value.rounded()))"
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

    private func loadDetailText(currentLoad: Double?, previousLoad: Double?) -> String {
        guard let currentLoad, let previousLoad else { return "Load data unavailable" }
        return "Load \(formatNumber(currentLoad)) vs \(formatNumber(previousLoad))"
    }

    private func buildRecoveryBalanceSummary(insight: WorkoutRecoveryBalanceInsight) -> String {
        let minutesText = insight.loadMinutes.map { "\(formatNumber($0)) min" } ?? "—"
        let workoutText = "\(insight.workoutCount) workouts"
        let recoveryText = insight.recoveryStatus?.title ?? "Recovery unknown"
        return "\(minutesText) • \(workoutText) • \(recoveryText)"
    }

    private func buildRecoveryBalanceDetail(insight: WorkoutRecoveryBalanceInsight) -> String {
        var parts: [String] = []
        if let resting = insight.latestRestingBpm {
            parts.append("RHR \(formatNumber(resting)) bpm")
        }
        if let hrv = insight.latestHrvMilliseconds {
            parts.append("HRV \(formatNumber(hrv)) ms")
        }
        return parts.isEmpty ? "Recovery signals unavailable" : parts.joined(separator: " • ")
    }

    private func trendDetailText(current: Double?, previous: Double?) -> String {
        guard let current, let previous else { return "Trend data unavailable" }
        let delta = current - previous
        let direction = delta > 0 ? "Up" : (delta < 0 ? "Down" : "Steady")
        return "\(direction) \(formatNumber(abs(delta))) vs prior period"
    }

    private func sleepBalanceDetail(insight: SleepTrainingBalanceInsight) -> String {
        var parts: [String] = []
        if let sleepDelta = insight.sleepDeltaHours {
            let direction = sleepDelta >= 0 ? "Up" : "Down"
            parts.append("Sleep \(direction) \(formatNumber(abs(sleepDelta))) hr")
        }
        if let loadDelta = insight.loadDeltaMinutes {
            let direction = loadDelta >= 0 ? "Up" : "Down"
            parts.append("Load \(direction) \(formatNumber(abs(loadDelta))) min")
        }
        return parts.isEmpty ? "Change data unavailable" : parts.joined(separator: " • ")
    }

    private func intensityDetailText(insight: WorkoutIntensityDistributionInsight) -> String {
        let total = insight.lowMinutes + insight.moderateMinutes + insight.highMinutes
        guard total > 0 else { return "Intensity data unavailable" }
        let lowPct = Int((insight.lowMinutes / total) * 100)
        let moderatePct = Int((insight.moderateMinutes / total) * 100)
        let highPct = Int((insight.highMinutes / total) * 100)
        return "Low \(lowPct)% • Mod \(moderatePct)% • High \(highPct)%"
    }

}
