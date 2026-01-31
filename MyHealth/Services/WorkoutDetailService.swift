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
    private let store: WorkoutStoreProtocol

    public init(store: WorkoutStoreProtocol) {
        self.store = store
    }

    public func updates(for id: UUID) -> AsyncStream<Workout?> {
        AsyncStream { continuation in
            let task = Task { [store] in
                let stream = await store.stream()
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
        try await store.delete(id: id)
    }
}
