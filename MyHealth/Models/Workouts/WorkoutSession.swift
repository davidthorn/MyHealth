//
//  WorkoutSession.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct WorkoutSession: Hashable, Sendable {
    public let type: WorkoutType
    public let startedAt: Date

    public init(type: WorkoutType, startedAt: Date) {
        self.type = type
        self.startedAt = startedAt
    }
}
