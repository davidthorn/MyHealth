//
//  CardioFitnessDetailUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct CardioFitnessDetailUpdate: Sendable {
    public let readings: [CardioFitnessReading]
    public let dayStats: [CardioFitnessDayStats]

    public init(readings: [CardioFitnessReading], dayStats: [CardioFitnessDayStats]) {
        self.readings = readings
        self.dayStats = dayStats
    }
}
