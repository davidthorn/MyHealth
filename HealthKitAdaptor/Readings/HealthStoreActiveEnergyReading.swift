//
//  HealthStoreActiveEnergyReading.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

public protocol HealthStoreActiveEnergyReading {
    var healthStore: HKHealthStore { get }
}

public extension HealthStoreActiveEnergyReading where Self: HealthStoreSampleQuerying {
    func fetchActiveEnergy(days: Int) async -> [CaloriesDay] {
        guard let activeType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return [] }
        let days = await fetchDailyCumulativeSum(
            quantityType: activeType,
            unit: .kilocalorie(),
            days: days
        ) { date, value in
            CaloriesDay(date: date, activeKilocalories: value)
        }
        return days.sorted { $0.date > $1.date }
    }
}
