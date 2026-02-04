//
//  CardioFitnessSummary.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct CardioFitnessSummary: Codable, Hashable, Sendable {
    public let latest: CardioFitnessReading?
    public let previous: [CardioFitnessReading]

    public init(latest: CardioFitnessReading?, previous: [CardioFitnessReading]) {
        self.latest = latest
        self.previous = previous
    }
}
