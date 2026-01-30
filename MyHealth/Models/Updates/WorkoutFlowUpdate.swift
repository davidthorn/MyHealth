//
//  WorkoutFlowUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct WorkoutFlowUpdate: Sendable {
    public let availableTypes: [WorkoutType]
    public let currentSession: WorkoutSession?

    public init(availableTypes: [WorkoutType], currentSession: WorkoutSession?) {
        self.availableTypes = availableTypes
        self.currentSession = currentSession
    }
}
