//
//  Workout+HealthKit.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit

public extension Workout {
    init?(healthKitWorkout: HKWorkout) {
        guard let type = WorkoutType(healthKitActivityType: healthKitWorkout.workoutActivityType) else {
            return nil
        }

        self.init(
            id: healthKitWorkout.uuid,
            title: type.displayName,
            type: type,
            startedAt: healthKitWorkout.startDate,
            endedAt: healthKitWorkout.endDate,
            sourceBundleIdentifier: healthKitWorkout.sourceRevision.source.bundleIdentifier
        )
    }
}
