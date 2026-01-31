//
//  RestingHeartRateDay.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct RestingHeartRateDay: Codable, Hashable, Sendable, Identifiable {
    public let date: Date
    public let averageBpm: Double

    public var id: Date { date }

    public init(date: Date, averageBpm: Double) {
        self.date = date
        self.averageBpm = averageBpm
    }
}
