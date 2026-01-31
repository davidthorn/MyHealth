//
//  HealthKitFlightsAdapterProtocol.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthKitFlightsAdapterProtocol {
    func requestAuthorization() async -> Bool
    func flightsSummaryStream(days: Int) -> AsyncStream<FlightsSummary>
}
