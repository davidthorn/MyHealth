//
//  HKQuantitySample+HeartRate.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import HealthKit

extension HKQuantitySample {
    nonisolated var heartRateBpm: Double {
        let unit = HKUnit.count().unitDivided(by: .minute())
        return quantity.doubleValue(for: unit)
    }
}
