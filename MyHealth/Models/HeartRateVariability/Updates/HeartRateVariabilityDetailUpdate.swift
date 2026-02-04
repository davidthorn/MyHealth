//
//  HeartRateVariabilityDetailUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct HeartRateVariabilityDetailUpdate: Sendable {
    public let readings: [HeartRateVariabilityReading]
    public let dayStats: [HeartRateVariabilityDayStats]

    public init(readings: [HeartRateVariabilityReading], dayStats: [HeartRateVariabilityDayStats]) {
        self.readings = readings
        self.dayStats = dayStats
    }
}
