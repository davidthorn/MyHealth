//
//  WorkoutStore.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public actor WorkoutStore: WorkoutStoreProtocol {
    private let store: DocumentStore<Workout>

    @MainActor
    public init(fileName: String? = nil) {
        self.store = DocumentStore(fileName: fileName ?? "Workouts")
    }

    public func stream() async -> AsyncStream<[Workout]> {
        await store.stream()
    }

    public func loadAll() async throws {
        try await store.loadAll()
    }

    public func bootstrap(_ items: [Workout]) async throws {
        try await store.bootstrap(items)
    }

    public func create(_ item: Workout) async throws {
        try await store.create(item)
    }

    public func read(id: Workout.ID) async -> Workout? {
        await store.read(id: id)
    }

    public func readAll() async -> [Workout] {
        await store.readAll()
    }

    public func update(_ item: Workout) async throws {
        try await store.update(item)
    }

    public func delete(id: Workout.ID) async throws {
        try await store.delete(id: id)
    }

    public func deleteAll() async throws {
        try await store.deleteAll()
    }
}
