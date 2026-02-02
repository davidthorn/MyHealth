//
//  RestingHeartRateReading+HealthKit.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

extension RestingHeartRateReading {
    init(sample: HKQuantitySample) {
        self.init(
            id: sample.uuid,
            bpm: sample.heartRateBpm,
            startDate: sample.startDate,
            endDate: sample.endDate,
            sourceName: sample.sourceRevision.source.name,
            sourceBundleIdentifier: sample.sourceRevision.source.bundleIdentifier,
            deviceName: sample.device?.name,
            metadata: sample.metadataStrings
        )
    }
}
