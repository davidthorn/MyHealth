//
//  HealthKitCardioFitnessAdapterProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthKitCardioFitnessAdapterProtocol: Sendable {
    func requestAuthorization() async -> Bool
    func cardioFitnessSummaryStream() -> AsyncStream<CardioFitnessSummary>
    func cardioFitnessReading(id: UUID) async throws -> CardioFitnessReading
    func cardioFitnessReadings(start: Date, end: Date) async -> [CardioFitnessReading]
    func cardioFitnessDailyStats(days: Int) async -> [CardioFitnessDayStats]
}
