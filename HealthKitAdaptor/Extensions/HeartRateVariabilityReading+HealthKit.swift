//
//  HeartRateVariabilityReading+HealthKit.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import HealthKit
import Models

extension HeartRateVariabilityReading {
    public init(sample: HKQuantitySample) {
        self.init(
            id: sample.uuid,
            milliseconds: sample.heartRateVariabilityMilliseconds,
            startDate: sample.startDate,
            endDate: sample.endDate,
            sourceName: sample.sourceRevision.source.name,
            deviceName: sample.device?.name,
            wasUserEntered: sample.metadata?[HKMetadataKeyWasUserEntered] as? Bool
        )
    }
}
