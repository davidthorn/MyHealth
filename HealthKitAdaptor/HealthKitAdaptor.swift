//
//  HealthKitAdapter.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

@MainActor
public final class HealthKitAdapter: HealthKitAdapterProtocol {
    private let storeAdaptor: HealthStoreAdaptorProtocol
    private let workouts: HealthKitWorkoutAdapterProtocol
    private let heartRates: HealthKitHeartRateAdapterProtocol
    private let steps: HealthKitStepsAdapterProtocol
    private let flights: HealthKitFlightsAdapterProtocol
    private let standHours: HealthKitStandHoursAdapterProtocol
    private let activeEnergy: HealthKitActiveEnergyAdapterProtocol
    private let activitySummary: HealthKitActivitySummaryAdapterProtocol
    private let restingHeartRate: HealthKitRestingHeartRateAdapterProtocol
    private let sleepAnalysis: HealthKitSleepAnalysisAdapterProtocol

    public var authorizationProvider: HealthAuthorizationProviding {
        storeAdaptor.authorizationProvider
    }

    public init(
        storeAdaptor: HealthStoreAdaptorProtocol,
        workouts: HealthKitWorkoutAdapterProtocol,
        heartRates: HealthKitHeartRateAdapterProtocol,
        steps: HealthKitStepsAdapterProtocol,
        flights: HealthKitFlightsAdapterProtocol,
        standHours: HealthKitStandHoursAdapterProtocol,
        activeEnergy: HealthKitActiveEnergyAdapterProtocol,
        activitySummary: HealthKitActivitySummaryAdapterProtocol,
        restingHeartRate: HealthKitRestingHeartRateAdapterProtocol,
        sleepAnalysis: HealthKitSleepAnalysisAdapterProtocol
    ) {
        self.storeAdaptor = storeAdaptor
        self.workouts = workouts
        self.heartRates = heartRates
        self.steps = steps
        self.flights = flights
        self.standHours = standHours
        self.activeEnergy = activeEnergy
        self.activitySummary = activitySummary
        self.restingHeartRate = restingHeartRate
        self.sleepAnalysis = sleepAnalysis
    }

    public static func live() -> HealthKitAdapter {
        let storeAdaptor = HealthStoreAdaptor()
        return HealthKitAdapter(
            storeAdaptor: storeAdaptor,
            workouts: HealthKitWorkoutAdapter(storeAdaptor: storeAdaptor),
            heartRates: HealthKitHeartRateAdapter(storeAdaptor: storeAdaptor),
            steps: HealthKitStepsAdapter(storeAdaptor: storeAdaptor),
            flights: HealthKitFlightsAdapter(storeAdaptor: storeAdaptor),
            standHours: HealthKitStandHoursAdapter(storeAdaptor: storeAdaptor),
            activeEnergy: HealthKitActiveEnergyAdapter(storeAdaptor: storeAdaptor),
            activitySummary: HealthKitActivitySummaryAdapter(storeAdaptor: storeAdaptor),
            restingHeartRate: HealthKitRestingHeartRateAdapter(storeAdaptor: storeAdaptor),
            sleepAnalysis: HealthKitSleepAnalysisAdapter(storeAdaptor: storeAdaptor)
        )
    }
    
    public func workoutsStream() -> AsyncStream<[Workout]> {
        workouts.workoutsStream()
    }

    public func workout(id: UUID) async throws -> Workout? {
        try await workouts.workout(id: id)
    }

    public func workoutRoute(id: UUID) async throws -> [WorkoutRoutePoint] {
        try await workouts.workoutRoute(id: id)
    }

    public func deleteWorkout(id: UUID) async throws {
        try await workouts.deleteWorkout(id: id)
    }

    public func heartRateSummaryStream() -> AsyncStream<HeartRateSummary> {
        heartRates.heartRateSummaryStream()
    }

    public func heartRateReading(id: UUID) async throws -> HeartRateReading {
        try await heartRates.heartRateReading(id: id)
    }

    public func heartRateReadings(from start: Date, to end: Date) async -> [HeartRateReading] {
        await heartRates.heartRateReadings(start: start, end: end)
    }

    public func stepsSummaryStream(days: Int) -> AsyncStream<StepsSummary> {
        steps.stepsSummaryStream(days: days)
    }

    public func flightsSummaryStream(days: Int) -> AsyncStream<FlightsSummary> {
        flights.flightsSummaryStream(days: days)
    }

    public func standHoursSummaryStream(days: Int) -> AsyncStream<StandHoursSummary> {
        standHours.standHoursSummaryStream(days: days)
    }

    public func activeEnergySummaryStream(days: Int) -> AsyncStream<CaloriesSummary> {
        activeEnergy.activeEnergySummaryStream(days: days)
    }

    public func restingHeartRateSummaryStream(days: Int) -> AsyncStream<RestingHeartRateSummary> {
        restingHeartRate.restingHeartRateSummaryStream(days: days)
    }

    public func restingHeartRateReadings(on date: Date) async -> [RestingHeartRateReading] {
        await restingHeartRate.restingHeartRateReadings(on: date)
    }

    public func activitySummaryStream(days: Int) -> AsyncStream<ActivityRingsSummary> {
        activitySummary.activitySummaryStream(days: days)
    }

    public func sleepAnalysisSummaryStream(days: Int) -> AsyncStream<SleepSummary> {
        sleepAnalysis.sleepAnalysisSummaryStream(days: days)
    }

    public func sleepAnalysisDay(date: Date) async -> SleepDay {
        await sleepAnalysis.sleepAnalysisDay(date: date)
    }

    public func activitySummaryDay(date: Date) async -> ActivityRingsDay {
        await activitySummary.activitySummaryDay(date: date)
    }
}
