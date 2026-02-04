//
//  HealthStoreCardioFitnessReading.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

public protocol HealthStoreCardioFitnessReading {
    var healthStore: HKHealthStore { get }
}

public extension HealthStoreCardioFitnessReading where Self: HealthStoreSampleQuerying {
    func fetchCardioFitnessReadings(limit: Int) async -> [CardioFitnessReading] {
        guard let vo2MaxType = HKQuantityType.quantityType(forIdentifier: .vo2Max) else { return [] }
        let sortDescriptor = sortByEndDate(ascending: false)
        let samples = await fetchQuantitySamples(
            quantityType: vo2MaxType,
            predicate: nil,
            limit: limit,
            sortDescriptors: [sortDescriptor]
        )
        return samples.map(CardioFitnessReading.init)
    }

    func fetchCardioFitnessReading(id: UUID) async throws -> CardioFitnessReading {
        guard let vo2MaxType = HKQuantityType.quantityType(forIdentifier: .vo2Max) else {
            throw HealthKitAdapterError.cardioFitnessReadingNotFound
        }
        let sample: HKQuantitySample = try await fetchSample(
            sampleType: vo2MaxType,
            id: id,
            errorOnMissing: HealthKitAdapterError.cardioFitnessReadingNotFound
        )
        return CardioFitnessReading(sample: sample)
    }

    func fetchCardioFitnessReadings(start: Date, end: Date) async -> [CardioFitnessReading] {
        guard let vo2MaxType = HKQuantityType.quantityType(forIdentifier: .vo2Max) else { return [] }
        let predicate = rangePredicate(start: start, end: end)
        let sortDescriptor = sortByEndDate(ascending: true)
        let samples = await fetchQuantitySamples(
            quantityType: vo2MaxType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        )
        return samples.map(CardioFitnessReading.init)
    }

    func fetchCardioFitnessDailyStats(days: Int) async -> [CardioFitnessDayStats] {
        guard let vo2MaxType = HKQuantityType.quantityType(forIdentifier: .vo2Max) else { return [] }
        let unit = HKUnit(from: "ml/kg*min")
        let stats = await fetchDailyDiscreteStats(
            quantityType: vo2MaxType,
            unit: unit,
            days: days
        )
        return stats.map {
            CardioFitnessDayStats(
                date: $0.date,
                averageVo2Max: $0.average,
                minVo2Max: $0.minimum,
                maxVo2Max: $0.maximum
            )
        }
    }
}
