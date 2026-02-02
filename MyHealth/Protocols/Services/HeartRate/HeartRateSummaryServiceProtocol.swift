//
//  HeartRateSummaryServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HeartRateSummaryServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates() -> AsyncStream<HeartRateSummaryUpdate>
    func dayReadings(start: Date, end: Date) async -> [HeartRateReading]
}
