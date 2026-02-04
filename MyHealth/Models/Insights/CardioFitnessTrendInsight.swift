//
//  CardioFitnessTrendInsight.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct CardioFitnessTrendInsight: Hashable, Sendable {
    public let windowStart: Date
    public let windowEnd: Date
    public let readings: [CardioFitnessReading]
    public let dayStats: [CardioFitnessDayStats]
    public let latestReading: CardioFitnessReading?
    public let currentAverage: Double?
    public let previousAverage: Double?
    public let delta: Double?
    public let status: CardioFitnessTrendStatus

    public init(
        windowStart: Date,
        windowEnd: Date,
        readings: [CardioFitnessReading],
        dayStats: [CardioFitnessDayStats],
        latestReading: CardioFitnessReading?,
        currentAverage: Double?,
        previousAverage: Double?,
        delta: Double?,
        status: CardioFitnessTrendStatus
    ) {
        self.windowStart = windowStart
        self.windowEnd = windowEnd
        self.readings = readings
        self.dayStats = dayStats
        self.latestReading = latestReading
        self.currentAverage = currentAverage
        self.previousAverage = previousAverage
        self.delta = delta
        self.status = status
    }
}
