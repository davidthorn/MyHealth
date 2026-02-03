//
//  BloodOxygenReading+HealthKit.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import HealthKit
import Models

extension BloodOxygenReading {
    public init(sample: HKQuantitySample) {
        self.init(
            id: sample.uuid,
            percent: sample.bloodOxygenPercent,
            startDate: sample.startDate,
            endDate: sample.endDate,
            sourceName: sample.sourceRevision.source.name,
            deviceName: sample.device?.name,
            wasUserEntered: sample.metadata?[HKMetadataKeyWasUserEntered] as? Bool
        )
    }
}
