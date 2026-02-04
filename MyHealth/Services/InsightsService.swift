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
        await healthKitAdapter.authorizationProvider.requestActivitySummaryAuthorization()
    }

    public func updates() -> AsyncStream<InsightsUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                continuation.yield(InsightsUpdate(title: "Insights", isAuthorized: false, insights: []))

                let isAuthorized = await healthKitAdapter.authorizationProvider.requestActivitySummaryAuthorization()
                guard !Task.isCancelled else { return }
                guard isAuthorized else {
                    continuation.yield(InsightsUpdate(title: "Insights", isAuthorized: false, insights: []))
                    continuation.finish()
                    return
                }

                let summary = await firstValue(from: healthKitAdapter.activitySummaryStream(days: 7))
                guard !Task.isCancelled else { return }
                let insights = buildInsights(from: summary)
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

    private func buildInsights(from summary: ActivityRingsSummary?) -> [InsightItem] {
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

    private func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "\(Int(value.rounded()))"
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
