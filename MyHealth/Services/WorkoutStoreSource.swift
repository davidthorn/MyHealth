//
//  WorkoutStoreSource.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

@MainActor
public final class WorkoutStoreSource: WorkoutDataSourceProtocol {
    private let store: WorkoutStore
    private var didRequestAuthorization: Bool = false

    public init(store: WorkoutStore) {
        self.store = store
    }

    public func requestAuthorization() async -> Bool {
        // Mocked authorization for the local store; first call returns false, then true.
        // Future: call HealthKit authorization and return the real result.
        if didRequestAuthorization {
            return true
        }

        didRequestAuthorization = true
        return false
    }

    public func workoutsStream() -> AsyncStream<[Workout]> {
        AsyncStream { continuation in
            let task = Task { [store] in
                let stream = await store.stream()
                for await items in stream {
                    if Task.isCancelled { break }
                    continuation.yield(items)
                }
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
