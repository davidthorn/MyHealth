//
//  ExerciseMinutesDayDetail.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct ExerciseMinutesDayDetail: Codable, Hashable, Sendable, Identifiable {
    public let date: Date
    public let minutes: Double
    public let goalMinutes: Double?

    public var id: Date { date }

    public var progress: Double {
        guard let goalMinutes, goalMinutes > 0 else { return 0 }
        return minutes / goalMinutes
    }

    public init(date: Date, minutes: Double, goalMinutes: Double?) {
        self.date = date
        self.minutes = minutes
        self.goalMinutes = goalMinutes
    }
}
