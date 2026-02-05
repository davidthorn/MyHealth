//
//  HealthKitSleepAnalysisAdapterProtocol.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthKitSleepAnalysisAdapterProtocol: Sendable {
    func requestAuthorization() async -> Bool
    func sleepAnalysisSummaryStream(days: Int) -> AsyncStream<SleepSummary>
    func sleepAnalysisDay(date: Date) async -> SleepDay
    func sleepEntries(days: Int) async -> [SleepEntry]
    func sleepEntries(on date: Date) async -> [SleepEntry]
    func saveSleepEntry(_ entry: SleepEntry) async throws
}
