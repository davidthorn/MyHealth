//
//  HealthKitAdapterProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthKitAdapterProtocol: Sendable {
    var authorizationProvider: HealthAuthorizationProviding { get }
    var workoutSession: HealthKitWorkoutSessionManaging { get }
    var hrvProvider: HealthKitHRVProviding { get }
    func workoutsStream() -> AsyncStream<[Workout]>
    func workout(id: UUID) async throws -> Workout?
    func workoutRoute(id: UUID) async throws -> [WorkoutRoutePoint]
    func deleteWorkout(id: UUID) async throws
    func heartRateSummaryStream() -> AsyncStream<HeartRateSummary>
    func heartRateReading(id: UUID) async throws -> HeartRateReading
    func heartRateReadings(from start: Date, to end: Date) async -> [HeartRateReading]
    func bloodOxygenSummaryStream() -> AsyncStream<BloodOxygenSummary>
    func bloodOxygenReading(id: UUID) async throws -> BloodOxygenReading
    func bloodOxygenReadings(from start: Date, to end: Date) async -> [BloodOxygenReading]
    func cardioFitnessSummaryStream() -> AsyncStream<CardioFitnessSummary>
    func cardioFitnessReading(id: UUID) async throws -> CardioFitnessReading
    func cardioFitnessReadings(from start: Date, to end: Date) async -> [CardioFitnessReading]
    func cardioFitnessDailyStats(days: Int) async -> [CardioFitnessDayStats]
    func stepsSummaryStream(days: Int) -> AsyncStream<StepsSummary>
    func flightsSummaryStream(days: Int) -> AsyncStream<FlightsSummary>
    func standHoursSummaryStream(days: Int) -> AsyncStream<StandHoursSummary>
    func exerciseMinutesSummaryStream(days: Int) -> AsyncStream<ExerciseMinutesSummary>
    func activeEnergySummaryStream(days: Int) -> AsyncStream<CaloriesSummary>
    func restingHeartRateSummaryStream(days: Int) -> AsyncStream<RestingHeartRateSummary>
    func restingHeartRateReadings(on date: Date) async -> [RestingHeartRateReading]
    func activitySummaryStream(days: Int) -> AsyncStream<ActivityRingsSummary>
    func sleepAnalysisSummaryStream(days: Int) -> AsyncStream<SleepSummary>
    func sleepAnalysisDay(date: Date) async -> SleepDay
    func sleepEntries(days: Int) async -> [SleepEntry]
    func sleepEntries(on date: Date) async -> [SleepEntry]
    func saveSleepEntry(_ entry: SleepEntry) async throws
    func activitySummaryDay(date: Date) async -> ActivityRingsDay
    func nutritionTypes() -> [NutritionType]
    func nutritionSamples(type: NutritionType, limit: Int) async -> [NutritionSample]
    func nutritionSamples(type: NutritionType, start: Date, end: Date) async -> [NutritionSample]
    func nutritionTotal(type: NutritionType, start: Date, end: Date) async -> Double?
    func saveNutritionSample(_ sample: NutritionSample) async throws
    func deleteNutritionSample(id: UUID, type: NutritionType) async throws
    func nutritionChangesStream() -> AsyncStream<Void>
}
