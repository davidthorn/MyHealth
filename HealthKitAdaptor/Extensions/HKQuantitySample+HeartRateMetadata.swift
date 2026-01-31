//
//  HKQuantitySample+HeartRateMetadata.swift
//  MyHealth
//
//  Created by Codex.
//

import HealthKit

extension HKQuantitySample {
    nonisolated func heartRateMetadata() -> (
        wasUserEntered: Bool?,
        motionContext: String?,
        sensorLocation: String?
    ) {
        let metadata = self.metadata ?? [:]
        let wasUserEntered = (metadata[HKMetadataKeyWasUserEntered] as? NSNumber)?.boolValue
        let motionContext = (metadata[HKMetadataKeyHeartRateMotionContext] as? NSNumber)
            .flatMap { HKHeartRateMotionContext(rawValue: $0.intValue) }
            .map(\.displayName)
        let sensorLocation = (metadata[HKMetadataKeyHeartRateSensorLocation] as? NSNumber)
            .flatMap { HKHeartRateSensorLocation(rawValue: $0.intValue) }
            .map(\.displayName)
        return (wasUserEntered, motionContext, sensorLocation)
    }
}
