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
}
