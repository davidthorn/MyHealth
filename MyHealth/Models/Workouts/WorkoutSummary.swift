//
//  WorkoutSummary.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct WorkoutSummary: Hashable, Identifiable, Sendable {
    public let id: UUID
    public let title: String
    public let type: WorkoutType
    public let date: Date

    public init(id: UUID, title: String, type: WorkoutType, date: Date) {
        self.id = id
        self.title = title
        self.type = type
        self.date = date
    }
}
