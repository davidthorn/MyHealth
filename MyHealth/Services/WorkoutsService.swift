//
//  WorkoutsService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

@MainActor
public final class WorkoutsService: WorkoutsServiceProtocol {
    public init() {}

    public func updates() -> AsyncStream<WorkoutsUpdate> {
        AsyncStream { continuation in
            continuation.yield(WorkoutsUpdate(title: "Workouts", workouts: []))
            continuation.finish()
        }
    }
}
