//
//  HealthKitHRVProviding.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthKitHRVProviding: Sendable {
    func summaryStream() -> AsyncStream<HeartRateVariabilitySummary>
    func reading(id: UUID) async throws -> HeartRateVariabilityReading
    func readings(start: Date, end: Date) async -> [HeartRateVariabilityReading]
    func dailyStats(days: Int) async -> [HeartRateVariabilityDayStats]
}
