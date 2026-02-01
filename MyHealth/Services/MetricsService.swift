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
                        activityRingsSummary: nil
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
                        activityRingsSummary: activityRingsSummary
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
}
