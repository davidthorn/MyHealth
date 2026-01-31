//
//  CaloriesDay.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct CaloriesDay: Codable, Hashable, Sendable, Identifiable {
    public let date: Date
    public let activeKilocalories: Double

    public var id: Date { date }

    public init(date: Date, activeKilocalories: Double) {
        self.date = date
        self.activeKilocalories = activeKilocalories
    }
}
