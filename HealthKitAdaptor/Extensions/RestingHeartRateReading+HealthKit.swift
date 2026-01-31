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
        let unit = HKUnit.count().unitDivided(by: .minute())
        let bpm = sample.quantity.doubleValue(for: unit)
        let metadata = sample.metadata ?? [:]
        let metadataStrings = metadata.reduce(into: [String: String]()) { result, item in
            result[String(describing: item.key)] = String(describing: item.value)
        }
        self.init(
            id: sample.uuid,
            bpm: bpm,
            startDate: sample.startDate,
            endDate: sample.endDate,
            sourceName: sample.sourceRevision.source.name,
            sourceBundleIdentifier: sample.sourceRevision.source.bundleIdentifier,
            deviceName: sample.device?.name,
            metadata: metadataStrings
        )
    }
}
