//
//  HeartRateStoreSource.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

@MainActor
public final class HeartRateStoreSource: HeartRateDataSourceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func requestAuthorization() async -> Bool {
        await healthKitAdapter.authorizationProvider.requestHeartRateAuthorization()
    }

    public func heartRateReadings(from start: Date, to end: Date) async -> [HeartRateReading] {
        await healthKitAdapter.heartRateReadings(from: start, to: end)
    }
}
