//
//  HealthStoreAdaptor.swift
//  MyHealth
//
//  Created by Codex.
//

@preconcurrency import Combine
import Foundation
import HealthKit

public final class HealthStoreAdaptor: HealthStoreAdaptorProtocol,
                                       HealthStoreHeartRateReading,
                                       HealthStoreBloodOxygenReading,
                                       HealthStoreCardioFitnessReading,
                                       HealthStoreHeartRateVariabilityReading,
                                       HealthStoreWorkoutReading,
                                       HealthStoreStepsReading,
                                       HealthStoreFlightsReading,
                                       HealthStoreStandHoursReading,
                                       HealthStoreExerciseMinutesReading,
                                       HealthStoreActiveEnergyReading,
                                       HealthStoreRestingHeartRateReading,
                                       HealthStoreActivitySummaryReading,
                                       HealthStoreSleepReading,
                                       HealthStoreNutritionReading,
                                       HealthStoreNutritionWriting,
                                       HealthStoreSleepWriting {
    
    public let healthStore: HKHealthStore
    public let authorizationProvider: HealthAuthorizationProviding
    private let nutritionChangesSubject = PassthroughSubject<Void, Never>()
    
    public init(
        healthStore: HKHealthStore = HKHealthStore(),
        authorizationProvider: HealthAuthorizationProviding? = nil
    ) {
        self.healthStore = healthStore
        self.authorizationProvider = authorizationProvider ?? HealthAuthorizationProvider(healthStore: healthStore)
    }

    public func nutritionChangesStream() -> AsyncStream<Void> {
        AsyncStream { continuation in
            let cancellable = nutritionChangesSubject.sink {
                continuation.yield(())
            }
            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
    }

    public func notifyNutritionChanged() {
        nutritionChangesSubject.send(())
    }
}
