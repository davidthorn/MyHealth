//
//  WorkoutDetailService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

@MainActor
public final class WorkoutDetailService: WorkoutDetailServiceProtocol {
    private let source: WorkoutDataSourceProtocol

    public init(source: WorkoutDataSourceProtocol) {
        self.source = source
    }

    public func updates(for id: UUID) -> AsyncStream<Workout?> {
        AsyncStream { continuation in
            let task = Task { [source] in
                let stream = source.workoutsStream()
                for await items in stream {
                    if Task.isCancelled { break }
                    let workout = items.first { $0.id == id }
                    continuation.yield(workout)
                }
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    public func delete(id: UUID) async throws {
        try await source.deleteWorkout(id: id)
    }
}
