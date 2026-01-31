//
//  FlightsSummaryServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol FlightsSummaryServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates() -> AsyncStream<FlightsSummaryUpdate>
}
