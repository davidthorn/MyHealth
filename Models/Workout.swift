//
//  Workout.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct Workout: Hashable, Identifiable, Sendable, Codable {
    public let id: UUID
    public let title: String
    public let type: WorkoutType
    public let startedAt: Date
    public let endedAt: Date

    public init(id: UUID, title: String, type: WorkoutType, startedAt: Date, endedAt: Date) {
        self.id = id
        self.title = title
        self.type = type
        self.startedAt = startedAt
        self.endedAt = endedAt
    }
}
