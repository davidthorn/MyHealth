//
//  HealthKitActivitySummaryAdapterProtocol.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthKitActivitySummaryAdapterProtocol: Sendable {
    func requestAuthorization() async -> Bool
    func activitySummaryStream(days: Int) -> AsyncStream<ActivityRingsSummary>
    func activitySummaryDay(date: Date) async -> ActivityRingsDay
}
