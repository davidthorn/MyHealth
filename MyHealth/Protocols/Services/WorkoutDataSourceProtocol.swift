//
//  WorkoutDataSourceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol WorkoutDataSourceProtocol {
    func requestAuthorization() async -> Bool
    func workoutsStream() -> AsyncStream<[Workout]>
}
