//
//  HealthKitHeartRateAdapterProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthKitHeartRateAdapterProtocol {
    func requestAuthorization() async -> Bool
    func heartRateSummaryStream() -> AsyncStream<HeartRateSummary>
    func heartRateReading(id: UUID) async throws -> HeartRateReading
    func heartRateReadings(start: Date, end: Date) async -> [HeartRateReading]
}
