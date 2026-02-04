//
//  HealthStoreFlightsReading.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

public protocol HealthStoreFlightsReading {
    var healthStore: HKHealthStore { get }
}

public extension HealthStoreFlightsReading where Self: HealthStoreSampleQuerying {
    func fetchFlightCounts(days: Int) async -> [FlightsDay] {
        guard let flightsType = HKQuantityType.quantityType(forIdentifier: .flightsClimbed) else { return [] }
        return await fetchDailyCumulativeSum(
            quantityType: flightsType,
            unit: .count(),
            days: days
        ) { date, value in
            FlightsDay(date: date, count: Int(value))
        }
    }
}
