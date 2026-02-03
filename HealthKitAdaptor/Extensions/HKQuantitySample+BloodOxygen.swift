//
//  HKQuantitySample+BloodOxygen.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import HealthKit

extension HKQuantitySample {
    nonisolated var bloodOxygenPercent: Double {
        let unit = HKUnit.percent()
        return quantity.doubleValue(for: unit) * 100
    }
}
