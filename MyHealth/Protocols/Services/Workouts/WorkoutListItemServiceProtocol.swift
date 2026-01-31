//
//  WorkoutListItemServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol WorkoutListItemServiceProtocol {
    func updates(for workout: Workout) -> AsyncStream<WorkoutListItemUpdate>
}
