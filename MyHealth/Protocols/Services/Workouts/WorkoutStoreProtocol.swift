//
//  WorkoutStoreProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol WorkoutStoreProtocol: Sendable {
    func stream() async -> AsyncStream<[Workout]>
    func loadAll() async throws
    func bootstrap(_ items: [Workout]) async throws
    func create(_ item: Workout) async throws
    func read(id: Workout.ID) async -> Workout?
    func readAll() async -> [Workout]
    func update(_ item: Workout) async throws
    func delete(id: Workout.ID) async throws
    func deleteAll() async throws
}
