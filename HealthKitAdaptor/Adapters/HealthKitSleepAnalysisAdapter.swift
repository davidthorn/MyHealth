//
//  HealthKitSleepAnalysisAdapter.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import Models

public final class HealthKitSleepAnalysisAdapter: HealthKitSleepAnalysisAdapterProtocol {
    private let storeAdaptor: HealthStoreAdaptorProtocol

    public init(storeAdaptor: HealthStoreAdaptorProtocol) {
        self.storeAdaptor = storeAdaptor
    }

    public static func live() -> HealthKitSleepAnalysisAdapter {
        HealthKitSleepAnalysisAdapter(storeAdaptor: HealthStoreAdaptor())
    }

    public func requestAuthorization() async -> Bool {
        await storeAdaptor.authorizationProvider.requestSleepAnalysisAuthorization()
    }

    public func sleepAnalysisSummaryStream(days: Int) -> AsyncStream<SleepSummary> {
        AsyncStream { continuation in
            let task = Task { [storeAdaptor] in
                let days = max(days, 1)
                let dayTotals = await storeAdaptor.fetchSleepAnalysis(days: days)
                guard !Task.isCancelled else { return }
                let latest = dayTotals.first
                let previous = Array(dayTotals.dropFirst())
                continuation.yield(SleepSummary(latest: latest, previous: previous))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    public func sleepAnalysisDay(date: Date) async -> SleepDay {
        await storeAdaptor.fetchSleepAnalysisDay(date: date)
    }

    public func sleepEntries(days: Int) async -> [SleepEntry] {
        await storeAdaptor.fetchSleepEntries(days: days)
    }

    public func sleepEntries(on date: Date) async -> [SleepEntry] {
        await storeAdaptor.fetchSleepEntries(on: date)
    }

    public func saveSleepEntry(_ entry: SleepEntry) async throws {
        try await storeAdaptor.saveSleepEntry(entry)
    }
}
