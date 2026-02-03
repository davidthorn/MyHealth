//
//  HealthKitRestingHeartRateAdapterProtocol.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthKitRestingHeartRateAdapterProtocol: Sendable {
    func requestAuthorization() async -> Bool
    func restingHeartRateSummaryStream(days: Int) -> AsyncStream<RestingHeartRateSummary>
    func restingHeartRateReadings(on date: Date) async -> [RestingHeartRateReading]
}
