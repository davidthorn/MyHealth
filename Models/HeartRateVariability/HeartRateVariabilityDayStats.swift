//
//  HeartRateVariabilityDayStats.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct HeartRateVariabilityDayStats: Codable, Hashable, Sendable, Identifiable {
    public let date: Date
    public let averageMilliseconds: Double?
    public let minMilliseconds: Double?
    public let maxMilliseconds: Double?

    public var id: Date { date }

    public init(date: Date, averageMilliseconds: Double?, minMilliseconds: Double?, maxMilliseconds: Double?) {
        self.date = date
        self.averageMilliseconds = averageMilliseconds
        self.minMilliseconds = minMilliseconds
        self.maxMilliseconds = maxMilliseconds
    }
}
