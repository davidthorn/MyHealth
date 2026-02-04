//
//  WorkoutIntensityZone.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum WorkoutIntensityZone: String, Hashable, Sendable, Identifiable, CaseIterable {
    case low
    case moderate
    case high

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .low:
            return "Low"
        case .moderate:
            return "Moderate"
        case .high:
            return "High"
        }
    }
}
