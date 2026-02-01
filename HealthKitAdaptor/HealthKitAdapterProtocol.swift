//
//  HealthKitAdapterProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthKitAdapterProtocol {
    var authorizationProvider: HealthAuthorizationProviding { get }
    func workoutsStream() -> AsyncStream<[Workout]>
    func workout(id: UUID) async throws -> Workout?
    func workoutRoute(id: UUID) async throws -> [WorkoutRoutePoint]
    func deleteWorkout(id: UUID) async throws
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
}
