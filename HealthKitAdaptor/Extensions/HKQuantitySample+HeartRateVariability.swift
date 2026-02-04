//
//  HKQuantitySample+HeartRateVariability.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import HealthKit

extension HKQuantitySample {
    nonisolated var heartRateVariabilityMilliseconds: Double {
        let unit = HKUnit.secondUnit(with: .milli)
        return quantity.doubleValue(for: unit)
    }
}
