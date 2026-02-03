//
//  WorkoutType+IconName.swift
//  MyHealth
//
//  Created by Codex.
//

import Models

public extension WorkoutType {
    var iconName: String {
        switch self {
        case .running:
            return "figure.run"
        case .walking:
            return "figure.walk"
        case .cycling:
            return "bicycle"
        case .swimming:
            return "figure.pool.swim"
        case .strength:
            return "dumbbell"
        case .yoga:
            return "figure.yoga"
        case .other:
            return "figure.mixed.cardio"
        @unknown default:
            return "figure.mixed.cardio"
        }
    }
}
