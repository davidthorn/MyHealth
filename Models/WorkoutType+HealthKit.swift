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

    var healthKitActivityType: HKWorkoutActivityType {
        switch self {
        case .running:
            return .running
        case .walking:
            return .walking
        case .cycling:
            return .cycling
        case .swimming:
            return .swimming
        case .strength:
            return .traditionalStrengthTraining
        case .yoga:
            return .yoga
        }
    }

    var healthKitLocationType: HKWorkoutSessionLocationType {
        switch self {
        case .running, .walking, .cycling:
            return .outdoor
        case .swimming, .strength, .yoga:
            return .indoor
        }
    }
}
