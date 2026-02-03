//
//  WorkoutStore.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

public actor WorkoutStore: WorkoutStoreProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func beginWorkout(type: WorkoutType) async throws {
        try await healthKitAdapter.workoutSession.beginWorkout(type: type)
    }

    public func pauseWorkout() async throws {
        try await healthKitAdapter.workoutSession.pauseWorkout()
    }

    public func resumeWorkout() async throws {
        try await healthKitAdapter.workoutSession.resumeWorkout()
    }

    public func appendRoutePoint(_ point: WorkoutRoutePoint) async throws {
        try await healthKitAdapter.workoutSession.appendRoutePoint(point)
    }

    public func endWorkout() async throws {
        try await healthKitAdapter.workoutSession.endWorkout()
    }
}
