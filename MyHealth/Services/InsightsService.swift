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

        let recentDays = Array(days.sorted { $0.date > $1.date }.prefix(7))
        guard !recentDays.isEmpty else { return [] }

        let totalDays = recentDays.count
        let closedAll = recentDays.filter { $0.closedRingsCount == 3 }.count
        let moveMet = recentDays.filter { $0.moveGoal > 0 && $0.moveValue >= $0.moveGoal }.count
        let exerciseMet = recentDays.filter { $0.exerciseGoal > 0 && $0.exerciseMinutes >= $0.exerciseGoal }.count
        let standMet = recentDays.filter { $0.standGoal > 0 && $0.standHours >= $0.standGoal }.count

        let averageClosed = recentDays.map { Double($0.closedRingsCount) }.reduce(0, +) / Double(totalDays)
        let score = Int((averageClosed / 3.0) * 100.0)

        let summaryText = "Closed all rings \(closedAll)/\(totalDays) days"
        let detailText = "Move goal met \(moveMet) days • Exercise goal met \(exerciseMet) days • Stand goal met \(standMet) days"
        let statusText = score >= 80 ? "Strong" : (score >= 50 ? "Steady" : "Needs Work")

        return [
            InsightItem(
                type: .activityConsistency,
                title: InsightType.activityConsistency.title,
                summary: summaryText,
                detail: detailText,
                status: statusText,
                icon: "figure.walk"
            )
        ]
    }
}
