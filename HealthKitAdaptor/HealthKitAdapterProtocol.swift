//
//  HealthKitAdapterProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

@MainActor
public protocol HealthKitAdapterProtocol {
    var authorizationProvider: HealthAuthorizationProviding { get }
    func workoutsStream() -> AsyncStream<[Workout]>
    func workout(id: UUID) async throws -> Workout?
    func workoutRoute(id: UUID) async throws -> [WorkoutRoutePoint]
    func deleteWorkout(id: UUID) async throws
    func beginWorkout(type: WorkoutType) async throws
    func pauseWorkout() async throws
    func resumeWorkout() async throws
    func endWorkout() async throws
    func heartRateSummaryStream() -> AsyncStream<HeartRateSummary>
    func heartRateReading(id: UUID) async throws -> HeartRateReading
    func heartRateReadings(from start: Date, to end: Date) async -> [HeartRateReading]
    func stepsSummaryStream(days: Int) -> AsyncStream<StepsSummary>
    func flightsSummaryStream(days: Int) -> AsyncStream<FlightsSummary>
    func standHoursSummaryStream(days: Int) -> AsyncStream<StandHoursSummary>
    func activeEnergySummaryStream(days: Int) -> AsyncStream<CaloriesSummary>
    func restingHeartRateSummaryStream(days: Int) -> AsyncStream<RestingHeartRateSummary>
    func restingHeartRateReadings(on date: Date) async -> [RestingHeartRateReading]
    func activitySummaryStream(days: Int) -> AsyncStream<ActivityRingsSummary>
    func sleepAnalysisSummaryStream(days: Int) -> AsyncStream<SleepSummary>
    func sleepAnalysisDay(date: Date) async -> SleepDay
    func activitySummaryDay(date: Date) async -> ActivityRingsDay
    func nutritionTypes() -> [NutritionType]
    func nutritionSamples(type: NutritionType, limit: Int) async -> [NutritionSample]
    func nutritionSamples(type: NutritionType, start: Date, end: Date) async -> [NutritionSample]
    func nutritionTotal(type: NutritionType, start: Date, end: Date) async -> Double?
    func saveNutritionSample(_ sample: NutritionSample) async throws
    func deleteNutritionSample(id: UUID, type: NutritionType) async throws
    func nutritionChangesStream() -> AsyncStream<Void>
}
