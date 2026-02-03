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
    public let sourceBundleIdentifier: String?

    public init(
        id: UUID,
        title: String,
        type: WorkoutType,
        startedAt: Date,
        endedAt: Date,
        sourceBundleIdentifier: String? = nil
    ) {
        self.id = id
        self.title = title
        self.type = type
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.sourceBundleIdentifier = sourceBundleIdentifier
    }
}
