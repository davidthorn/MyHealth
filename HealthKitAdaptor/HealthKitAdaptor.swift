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
    private let workouts: HealthKitWorkoutAdapterProtocol
    private let heartRates: HealthKitHeartRateAdapterProtocol
    private let steps: HealthKitStepsAdapterProtocol
    private let flights: HealthKitFlightsAdapterProtocol
    private let standHours: HealthKitStandHoursAdapterProtocol
    private let activeEnergy: HealthKitActiveEnergyAdapterProtocol
    private let activitySummary: HealthKitActivitySummaryAdapterProtocol
    private let sleepAnalysis: HealthKitSleepAnalysisAdapterProtocol
    
    public init(
        workouts: HealthKitWorkoutAdapterProtocol,
        heartRates: HealthKitHeartRateAdapterProtocol,
        steps: HealthKitStepsAdapterProtocol,
        flights: HealthKitFlightsAdapterProtocol,
        standHours: HealthKitStandHoursAdapterProtocol,
        activeEnergy: HealthKitActiveEnergyAdapterProtocol,
        activitySummary: HealthKitActivitySummaryAdapterProtocol,
        sleepAnalysis: HealthKitSleepAnalysisAdapterProtocol
    ) {
        self.workouts = workouts
        self.heartRates = heartRates
        self.steps = steps
        self.flights = flights
        self.standHours = standHours
        self.activeEnergy = activeEnergy
        self.activitySummary = activitySummary
        self.sleepAnalysis = sleepAnalysis
    }

    public static func live() -> HealthKitAdapter {
        let storeAdaptor = HealthStoreAdaptor()
        return HealthKitAdapter(
            workouts: HealthKitWorkoutAdapter(storeAdaptor: storeAdaptor),
            heartRates: HealthKitHeartRateAdapter(storeAdaptor: storeAdaptor),
            steps: HealthKitStepsAdapter(storeAdaptor: storeAdaptor),
            flights: HealthKitFlightsAdapter(storeAdaptor: storeAdaptor),
            standHours: HealthKitStandHoursAdapter(storeAdaptor: storeAdaptor),
            activeEnergy: HealthKitActiveEnergyAdapter(storeAdaptor: storeAdaptor),
            activitySummary: HealthKitActivitySummaryAdapter(storeAdaptor: storeAdaptor),
            sleepAnalysis: HealthKitSleepAnalysisAdapter(storeAdaptor: storeAdaptor)
        )
    }
    
    public func requestAuthorization() async -> Bool {
        await workouts.requestAuthorization()
    }

    public func requestHeartRateAuthorization() async -> Bool {
        await heartRates.requestAuthorization()
    }

    public func requestStepsAuthorization() async -> Bool {
        await steps.requestAuthorization()
    }

    public func requestFlightsAuthorization() async -> Bool {
        await flights.requestAuthorization()
    }

    public func requestStandHoursAuthorization() async -> Bool {
        await standHours.requestAuthorization()
    }

    public func requestActiveEnergyAuthorization() async -> Bool {
        await activeEnergy.requestAuthorization()
    }

    public func requestActivitySummaryAuthorization() async -> Bool {
        await activitySummary.requestAuthorization()
    }

    public func requestSleepAnalysisAuthorization() async -> Bool {
        await sleepAnalysis.requestAuthorization()
    }

    public func workoutsStream() -> AsyncStream<[Workout]> {
        workouts.workoutsStream()
    }

    public func workout(id: UUID) async throws -> Workout? {
        try await workouts.workout(id: id)
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
