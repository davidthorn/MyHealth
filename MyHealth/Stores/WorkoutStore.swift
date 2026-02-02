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
        try await healthKitAdapter.beginWorkout(type: type)
    }

    public func pauseWorkout() async throws {
        try await healthKitAdapter.pauseWorkout()
    }

    public func resumeWorkout() async throws {
        try await healthKitAdapter.resumeWorkout()
    }

    public func endWorkout() async throws {
        try await healthKitAdapter.endWorkout()
    }
}
