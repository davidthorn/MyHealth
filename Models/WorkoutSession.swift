//
//  WorkoutSession.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct WorkoutSession: Hashable, Sendable {
    public let type: WorkoutType
    public let startedAt: Date?
    public let status: WorkoutSessionStatus
    public let pausedAt: Date?
    public let totalPausedSeconds: TimeInterval

    public init(
        type: WorkoutType,
        startedAt: Date? = nil,
        status: WorkoutSessionStatus = .notStarted,
        pausedAt: Date? = nil,
        totalPausedSeconds: TimeInterval = 0
    ) {
        self.type = type
        self.startedAt = startedAt
        self.status = status
        self.pausedAt = pausedAt
        self.totalPausedSeconds = totalPausedSeconds
    }
}
