//
//  HKQuantitySample+CardioFitness.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import HealthKit

extension HKQuantitySample {
    nonisolated var vo2MaxValue: Double {
        let unit = HKUnit(from: "ml/kg*min")
        return quantity.doubleValue(for: unit)
    }
}
