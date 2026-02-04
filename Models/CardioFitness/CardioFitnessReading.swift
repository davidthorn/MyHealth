//
//  CardioFitnessReading.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct CardioFitnessReading: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID
    public let vo2Max: Double
    public let date: Date
    public let startDate: Date
    public let endDate: Date

    public init(id: UUID = UUID(), vo2Max: Double, date: Date, startDate: Date, endDate: Date) {
        self.id = id
        self.vo2Max = vo2Max
        self.date = date
        self.startDate = startDate
        self.endDate = endDate
    }
}
