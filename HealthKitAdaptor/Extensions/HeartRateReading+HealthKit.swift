//
//  HeartRateReading+HealthKit.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

extension HeartRateReading {
    public init(sample: HKQuantitySample) {
        let metadata = sample.heartRateMetadata()
        self.init(
            id: sample.uuid,
            bpm: sample.heartRateBpm,
            date: sample.endDate,
            startDate: sample.startDate,
            endDate: sample.endDate,
            sourceName: sample.sourceRevision.source.name,
            deviceName: sample.device?.name,
            wasUserEntered: metadata.wasUserEntered,
            motionContext: metadata.motionContext,
            sensorLocation: metadata.sensorLocation
        )
    }
}
