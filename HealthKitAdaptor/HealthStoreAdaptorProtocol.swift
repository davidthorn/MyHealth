//
//  HealthStoreAdaptorProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthStoreAdaptorProtocol {
    func requestWorkoutAuthorization() async -> Bool
    func requestHeartRateAuthorization() async -> Bool
    func fetchWorkouts() async -> [Workout]
    func fetchWorkout(id: UUID) async throws -> Workout
    func deleteWorkout(id: UUID) async throws
    func fetchHeartRateReadings(limit: Int) async -> [HeartRateReading]
    func fetchHeartRateReading(id: UUID) async throws -> HeartRateReading
}
