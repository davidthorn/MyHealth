//
//  ExerciseMinutesSummary.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct ExerciseMinutesSummary: Codable, Hashable, Sendable {
    public let latest: ExerciseMinutesDay?
    public let previous: [ExerciseMinutesDay]

    public init(latest: ExerciseMinutesDay?, previous: [ExerciseMinutesDay]) {
        self.latest = latest
        self.previous = previous
    }
}
