//
//  HealthStoreAdaptor.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit

@MainActor
public final class HealthStoreAdaptor: HealthStoreAdaptorProtocol,
                                       HealthStoreHeartRateReading,
                                       HealthStoreWorkoutReading,
                                       HealthStoreStepsReading,
                                       HealthStoreFlightsReading,
                                       HealthStoreStandHoursReading,
                                       HealthStoreActiveEnergyReading,
                                       HealthStoreRestingHeartRateReading,
                                       HealthStoreActivitySummaryReading,
                                       HealthStoreSleepReading {
    
    internal let healthStore: HKHealthStore
    public let authorizationProvider: HealthAuthorizationProviding
    
    public init(
        healthStore: HKHealthStore = HKHealthStore(),
        authorizationProvider: HealthAuthorizationProviding? = nil
    ) {
        self.healthStore = healthStore
        self.authorizationProvider = authorizationProvider ?? HealthAuthorizationProvider(healthStore: healthStore)
    }
}
