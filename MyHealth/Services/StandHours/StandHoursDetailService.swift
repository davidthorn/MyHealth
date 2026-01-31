//
//  StandHoursDetailService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

@MainActor
public final class StandHoursDetailService: StandHoursDetailServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func requestAuthorization() async -> Bool {
        await healthKitAdapter.requestStandHoursAuthorization()
    }

    public func updates() -> AsyncStream<StandHoursDetailUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                for await summary in healthKitAdapter.standHoursSummaryStream(days: 30) {
                    guard !Task.isCancelled else { return }
                    continuation.yield(StandHoursDetailUpdate(summary: summary))
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
