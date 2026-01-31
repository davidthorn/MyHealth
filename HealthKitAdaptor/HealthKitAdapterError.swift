//
//  HealthKitAdapterError.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum HealthKitAdapterError: Error {
    case deleteFailed
    case workoutNotFound
    case unmappedWorkoutType
}
