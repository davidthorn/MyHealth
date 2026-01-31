//
//  WorkoutType+HealthKit.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit

public extension WorkoutType {
    init?(healthKitActivityType: HKWorkoutActivityType) {
        switch healthKitActivityType {
        case .running:
            self = .running
        case .walking:
            self = .walking
        case .cycling:
            self = .cycling
        case .swimming:
            self = .swimming
        case .traditionalStrengthTraining, .functionalStrengthTraining:
            self = .strength
        case .yoga:
            self = .yoga
        default:
            return nil
        }
    }
}
