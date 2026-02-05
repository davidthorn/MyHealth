//
//  SleepReadingDetailService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

@MainActor
public final class SleepReadingDetailService: SleepReadingDetailServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func requestAuthorization() async -> Bool {
        await healthKitAdapter.authorizationProvider.requestSleepAnalysisAuthorization()
    }

    public func updates(for date: Date) -> AsyncStream<SleepReadingDetailUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                let day = await healthKitAdapter.sleepAnalysisDay(date: date)
                let entries = await healthKitAdapter.sleepEntries(on: date)
                guard !Task.isCancelled else { return }
                continuation.yield(SleepReadingDetailUpdate(day: day, entries: entries))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
