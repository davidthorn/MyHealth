//
//  HealthKitAdapter.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Foundation
import Models

@MainActor
public final class HealthKitAdapter: HealthKitAdapterProtocol {
    private let workouts: HealthKitWorkoutAdapterProtocol
    private let heartRates: HealthKitHeartRateAdapterProtocol
    
    public init(
        workouts: HealthKitWorkoutAdapterProtocol,
        heartRates: HealthKitHeartRateAdapterProtocol
    ) {
        self.workouts = workouts
        self.heartRates = heartRates
    }

    public static func live() -> HealthKitAdapter {
        let storeAdaptor = HealthStoreAdaptor()
        return HealthKitAdapter(
            workouts: HealthKitWorkoutAdapter(storeAdaptor: storeAdaptor),
            heartRates: HealthKitHeartRateAdapter(storeAdaptor: storeAdaptor)
        )
    }
    
    public func requestAuthorization() async -> Bool {
        await workouts.requestAuthorization()
    }

    public func requestHeartRateAuthorization() async -> Bool {
        await heartRates.requestAuthorization()
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
}
