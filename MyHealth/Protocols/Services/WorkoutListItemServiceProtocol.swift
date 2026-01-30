//
//  WorkoutListItemServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol WorkoutListItemServiceProtocol {
    func updates(for workout: Workout) -> AsyncStream<WorkoutListItemUpdate>
}
