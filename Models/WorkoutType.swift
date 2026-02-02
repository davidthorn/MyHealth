//
//  WorkoutType.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum WorkoutType: String, CaseIterable, Hashable, Identifiable, Codable, Sendable {
    case running
    case walking
    case cycling
    case swimming
    case strength
    case yoga

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .running: return "Running"
        case .walking: return "Walking"
        case .cycling: return "Cycling"
        case .swimming: return "Swimming"
        case .strength: return "Strength Training"
        case .yoga: return "Yoga"
        }
    }

    public static var outdoorSupported: [WorkoutType] {
        [.walking, .running, .cycling]
    }
}
