//
//  SleepEntryService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

@MainActor
public final class SleepEntryService: SleepEntryServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func requestReadAuthorization() async -> Bool {
        await healthKitAdapter.authorizationProvider.requestSleepAnalysisAuthorization()
    }

    public func requestWriteAuthorization() async -> Bool {
        await healthKitAdapter.authorizationProvider.requestSleepAnalysisWriteAuthorization()
    }

    public func entries(days: Int) -> AsyncStream<[SleepEntry]> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                let days = max(days, 1)
                let entries = await healthKitAdapter.sleepEntries(days: days)
                let sorted = entries.sorted { $0.startDate > $1.startDate }
                continuation.yield(sorted)
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    public func saveSleepEntry(_ entry: SleepEntry) async throws {
        try await healthKitAdapter.saveSleepEntry(entry)
    }
}
