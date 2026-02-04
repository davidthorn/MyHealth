//
//  CardioFitnessReading+HealthKit.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

extension CardioFitnessReading {
    public init(sample: HKQuantitySample) {
        self.init(
            id: sample.uuid,
            vo2Max: sample.vo2MaxValue,
            date: sample.endDate,
            startDate: sample.startDate,
            endDate: sample.endDate
        )
    }
}
