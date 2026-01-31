//
//  FlightsSummaryService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

@MainActor
public final class FlightsSummaryService: FlightsSummaryServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func requestAuthorization() async -> Bool {
        await healthKitAdapter.requestFlightsAuthorization()
    }

    public func updates() -> AsyncStream<FlightsSummaryUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                for await summary in healthKitAdapter.flightsSummaryStream(days: 14) {
                    guard !Task.isCancelled else { return }
                    continuation.yield(FlightsSummaryUpdate(summary: summary))
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
