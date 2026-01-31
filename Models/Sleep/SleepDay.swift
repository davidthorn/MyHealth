//
//  SleepDay.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct SleepDay: Codable, Hashable, Sendable, Identifiable {
    public let date: Date
    public let durationSeconds: TimeInterval

    public var id: Date { date }

    public init(date: Date, durationSeconds: TimeInterval) {
        self.date = date
        self.durationSeconds = durationSeconds
    }
}
