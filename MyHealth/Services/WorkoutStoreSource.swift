//
//  WorkoutStoreSource.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models
import HealthKitAdaptor

@MainActor
public final class WorkoutStoreSource: WorkoutDataSourceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func requestAuthorization() async -> Bool {
        await healthKitAdapter.requestAuthorization()
    }

    public func workoutsStream() -> AsyncStream<[Workout]> {
        healthKitAdapter.workoutsStream()
    }
}
