//
//  ExerciseMinutesDay.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct ExerciseMinutesDay: Codable, Hashable, Sendable, Identifiable {
    public let date: Date
    public let minutes: Double

    public var id: Date { date }

    public init(date: Date, minutes: Double) {
        self.date = date
        self.minutes = minutes
    }
}
