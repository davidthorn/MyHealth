//
//  CardioFitnessDayStats.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct CardioFitnessDayStats: Codable, Hashable, Sendable, Identifiable {
    public let id: UUID
    public let date: Date
    public let averageVo2Max: Double?
    public let minVo2Max: Double?
    public let maxVo2Max: Double?

    public init(
        id: UUID = UUID(),
        date: Date,
        averageVo2Max: Double?,
        minVo2Max: Double?,
        maxVo2Max: Double?
    ) {
        self.id = id
        self.date = date
        self.averageVo2Max = averageVo2Max
        self.minVo2Max = minVo2Max
        self.maxVo2Max = maxVo2Max
    }
}
