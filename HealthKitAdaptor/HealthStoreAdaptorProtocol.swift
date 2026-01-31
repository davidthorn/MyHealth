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
    func requestStepsAuthorization() async -> Bool
    func requestFlightsAuthorization() async -> Bool
    func requestStandHoursAuthorization() async -> Bool
    func fetchWorkouts() async -> [Workout]
    func fetchWorkout(id: UUID) async throws -> Workout
    func deleteWorkout(id: UUID) async throws
    func fetchHeartRateReadings(limit: Int) async -> [HeartRateReading]
    func fetchHeartRateReading(id: UUID) async throws -> HeartRateReading
    func fetchStepCounts(days: Int) async -> [StepsDay]
    func fetchFlightCounts(days: Int) async -> [FlightsDay]
    func fetchStandHourCounts(days: Int) async -> [StandHourDay]
}
