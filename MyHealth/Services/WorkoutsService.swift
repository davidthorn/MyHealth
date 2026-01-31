//
//  WorkoutsService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

@MainActor
public final class WorkoutsService: WorkoutsServiceProtocol {
    private let source: WorkoutDataSourceProtocol

    public init(source: WorkoutDataSourceProtocol) {
        self.source = source
    }

    public func requestAuthorization() async -> Bool {
        await source.requestAuthorization()
    }

    public func updates() -> AsyncStream<WorkoutsUpdate> {
        AsyncStream { continuation in
            let task = Task { [source] in
                let stream = source.workoutsStream()
                for await items in stream {
                    if Task.isCancelled { break }
                    continuation.yield(WorkoutsUpdate(title: "Workouts", workouts: items))
                }
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
