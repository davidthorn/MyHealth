//
//  HealthKitFlightsAdapterProtocol.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthKitFlightsAdapterProtocol: Sendable {
    func requestAuthorization() async -> Bool
    func flightsSummaryStream(days: Int) -> AsyncStream<FlightsSummary>
}
