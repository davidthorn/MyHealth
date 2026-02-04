//
//  HealthStoreStepsReading.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

public protocol HealthStoreStepsReading {
    var healthStore: HKHealthStore { get }
}

public extension HealthStoreStepsReading where Self: HealthStoreSampleQuerying {
    func fetchStepCounts(days: Int) async -> [StepsDay] {
        guard let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return [] }
        return await fetchDailyCumulativeSum(
            quantityType: stepsType,
            unit: .count(),
            days: days
        ) { date, value in
            StepsDay(date: date, count: Int(value))
        }
    }
}
