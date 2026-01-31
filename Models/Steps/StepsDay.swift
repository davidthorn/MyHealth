//
//  StepsDay.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct StepsDay: Codable, Hashable, Sendable, Identifiable {
    public let date: Date
    public let count: Int

    public var id: Date { date }

    public init(date: Date, count: Int) {
        self.date = date
        self.count = count
    }
}
