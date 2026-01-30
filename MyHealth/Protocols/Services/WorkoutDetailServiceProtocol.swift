//
//  WorkoutDetailServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol WorkoutDetailServiceProtocol {
    func updates(for id: UUID) -> AsyncStream<WorkoutDetailUpdate>
    func delete(id: UUID) async throws
}
