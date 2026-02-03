//
//  HealthKitBloodOxygenAdapterProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthKitBloodOxygenAdapterProtocol: Sendable {
    func requestAuthorization() async -> Bool
    func bloodOxygenSummaryStream() -> AsyncStream<BloodOxygenSummary>
    func bloodOxygenReading(id: UUID) async throws -> BloodOxygenReading
    func bloodOxygenReadings(start: Date, end: Date) async -> [BloodOxygenReading]
}
