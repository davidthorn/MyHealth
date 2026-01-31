//
//  CaloriesSummary.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct CaloriesSummary: Codable, Hashable, Sendable {
    public let latest: CaloriesDay?
    public let previous: [CaloriesDay]

    public init(latest: CaloriesDay?, previous: [CaloriesDay]) {
        self.latest = latest
        self.previous = previous
    }
}
