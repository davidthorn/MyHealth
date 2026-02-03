//
//  HealthAuthorizationProvider.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import HealthKit
import Models

public final class HealthAuthorizationProvider: HealthAuthorizationProviding {
    private let healthStore: HKHealthStore

    public init(healthStore: HKHealthStore) {
        self.healthStore = healthStore
    }

    public func requestAllAuthorization() async -> Bool {
        var readTypes = Set<HKObjectType>()
        readTypes.insert(HKObjectType.workoutType())
        readTypes.insert(HKSeriesType.workoutRoute())

        if let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) {
            readTypes.insert(heartRateType)
        }
        if let oxygenType = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation) {
            readTypes.insert(oxygenType)
        }
        if let restingType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate) {
            readTypes.insert(restingType)
        }
        if let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) {
            readTypes.insert(stepType)
        }
        if let flightsType = HKQuantityType.quantityType(forIdentifier: .flightsClimbed) {
            readTypes.insert(flightsType)
        }
        if let standType = HKObjectType.categoryType(forIdentifier: .appleStandHour) {
            readTypes.insert(standType)
        }
        if let activeType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) {
            readTypes.insert(activeType)
        }
        if let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) {
            readTypes.insert(sleepType)
        }
        readTypes.insert(HKObjectType.activitySummaryType())
        return await requestAuthorization(readTypes: readTypes)
    }

    public func requestWorkoutAuthorization() async -> Bool {
        let workoutType = HKObjectType.workoutType()
        let routeType = HKSeriesType.workoutRoute()
        return await requestAuthorization(readTypes: [workoutType, routeType])
    }

    public func requestCreateWorkoutAuthorization() async -> Bool {
        let workoutType = HKObjectType.workoutType()
        let routeType = HKSeriesType.workoutRoute()
        return await requestAuthorization(readTypes: [workoutType, routeType], shareTypes: [workoutType, routeType])
    }
    
    public func requestHeartRateAuthorization() async -> Bool {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return false }
        return await requestAuthorization(readTypes: [heartRateType])
    }

    public func requestBloodOxygenAuthorization() async -> Bool {
        guard let oxygenType = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation) else { return false }
        return await requestAuthorization(readTypes: [oxygenType])
    }

    public func requestStepsAuthorization() async -> Bool {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return false }
        return await requestAuthorization(readTypes: [stepType])
    }

    public func requestFlightsAuthorization() async -> Bool {
        guard let flightsType = HKQuantityType.quantityType(forIdentifier: .flightsClimbed) else { return false }
        return await requestAuthorization(readTypes: [flightsType])
    }

    public func requestStandHoursAuthorization() async -> Bool {
        guard let standType = HKObjectType.categoryType(forIdentifier: .appleStandHour) else { return false }
        return await requestAuthorization(readTypes: [standType])
    }

    public func requestActiveEnergyAuthorization() async -> Bool {
        guard let activeType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return false }
        return await requestAuthorization(readTypes: [activeType])
    }

    public func requestSleepAnalysisAuthorization() async -> Bool {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return false }
        return await requestAuthorization(readTypes: [sleepType])
    }

    public func requestActivitySummaryAuthorization() async -> Bool {
        let summaryType = HKObjectType.activitySummaryType()
        return await requestAuthorization(readTypes: [summaryType])
    }

    public func requestRestingHeartRateAuthorization() async -> Bool {
        guard let restingType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate) else { return false }
        return await requestAuthorization(readTypes: [restingType])
    }

    public func requestNutritionReadAuthorization(type: NutritionType) async -> Bool {
        let readTypes = Self.nutritionReadTypes(for: type)
        return await requestAuthorization(readTypes: readTypes)
    }

    public func requestNutritionWriteAuthorization(type: NutritionType) async -> Bool {
        let shareTypes = Self.nutritionShareTypes(for: type)
        let readTypes = Self.nutritionReadTypes(for: type)
        return await requestAuthorization(readTypes: readTypes, shareTypes: shareTypes)
    }

    public func requestAuthorization(readTypes: Set<HKObjectType>) async -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else { return false }
        guard !readTypes.isEmpty else { return false }
        return await withCheckedContinuation { continuation in
            healthStore.requestAuthorization(toShare: [], read: readTypes) { success, _ in
                continuation.resume(returning: success)
            }
        }
    }

    private func requestAuthorization(readTypes: Set<HKObjectType>, shareTypes: Set<HKSampleType>) async -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else { return false }
        guard !readTypes.isEmpty || !shareTypes.isEmpty else { return false }
        return await withCheckedContinuation { continuation in
            healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { success, _ in
                continuation.resume(returning: success)
            }
        }
    }

    private nonisolated static func nutritionReadTypes(for type: NutritionType) -> Set<HKObjectType> {
        guard let identifier = type.quantityIdentifier,
              let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            return []
        }
        return [quantityType]
    }

    private nonisolated static func nutritionShareTypes(for type: NutritionType) -> Set<HKSampleType> {
        guard let identifier = type.quantityIdentifier,
              let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            return []
        }
        return [quantityType]
    }
}
