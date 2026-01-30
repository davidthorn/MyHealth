//
//  WorkoutsService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

@MainActor
public final class WorkoutsService: WorkoutsServiceProtocol {
    private let store: WorkoutStore

    public init(store: WorkoutStore) {
        self.store = store
    }

    public func updates() -> AsyncStream<WorkoutsUpdate> {
        AsyncStream { continuation in
            let task = Task { [store] in
                try? await store.loadAll()
                let stream = await store.stream()
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
