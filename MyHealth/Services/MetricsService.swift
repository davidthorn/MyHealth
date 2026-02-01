//
//  MetricsService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

@MainActor
public final class MetricsService: MetricsServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func updates() -> AsyncStream<MetricsUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                continuation.yield(
                    MetricsUpdate(
                        title: "Metrics",
                        heartRateSummary: nil,
                        restingHeartRateSummary: nil,
                        stepsSummary: nil,
                        flightsSummary: nil,
                        standHoursSummary: nil,
                        caloriesSummary: nil,
                        sleepSummary: nil,
                        activityRingsSummary: nil,
                        nutritionSummary: nil
                    )
                )

                let isAuthorized = await healthKitAdapter.authorizationProvider.requestAllAuthorization()
                guard isAuthorized, !Task.isCancelled else {
                    continuation.finish()
                    return
                }

                let heartRateSummary = await firstValue(from: healthKitAdapter.heartRateSummaryStream())
                let restingHeartRateSummary = await firstValue(from: healthKitAdapter.restingHeartRateSummaryStream(days: 7))
                let stepsSummary = await firstValue(from: healthKitAdapter.stepsSummaryStream(days: 7))
                let flightsSummary = await firstValue(from: healthKitAdapter.flightsSummaryStream(days: 7))
                let standHoursSummary = await firstValue(from: healthKitAdapter.standHoursSummaryStream(days: 7))
                let caloriesSummary = await firstValue(from: healthKitAdapter.activeEnergySummaryStream(days: 7))
                let sleepSummary = await firstValue(from: healthKitAdapter.sleepAnalysisSummaryStream(days: 7))
                let activityRingsSummary = await firstValue(from: healthKitAdapter.activitySummaryStream(days: 7))
                let nutritionSummary = await nutritionDaySummary(using: healthKitAdapter)

                guard !Task.isCancelled else {
                    continuation.finish()
                    return
                }

                continuation.yield(
                    MetricsUpdate(
                        title: "Metrics",
                        heartRateSummary: heartRateSummary,
                        restingHeartRateSummary: restingHeartRateSummary,
                        stepsSummary: stepsSummary,
                        flightsSummary: flightsSummary,
                        standHoursSummary: standHoursSummary,
                        caloriesSummary: caloriesSummary,
                        sleepSummary: sleepSummary,
                        activityRingsSummary: activityRingsSummary,
                        nutritionSummary: nutritionSummary
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

    private func nutritionDaySummary(using adapter: HealthKitAdapterProtocol) async -> NutritionDaySummary? {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else { return nil }

        var totals: [NutritionDayTotal] = []
        for type in adapter.nutritionTypes() {
            let samples = await adapter.nutritionSamples(type: type, start: startDate, end: endDate)
            let totalValue = samples.reduce(0) { $0 + $1.value }
            guard totalValue > 0 else { continue }
            totals.append(NutritionDayTotal(type: type, value: totalValue, unit: type.unit))
        }

        guard !totals.isEmpty else { return nil }
        let sorted = totals.sorted { $0.value > $1.value }
        return NutritionDaySummary(date: startDate, totals: sorted)
    }
}
