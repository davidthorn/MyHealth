//
//  WorkoutIntensityBalanceStatus.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum WorkoutIntensityBalanceStatus: String, Hashable, Sendable, Identifiable {
    case lowBias
    case moderateBias
    case highBias
    case balanced
    case unclear

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .lowBias:
            return "Low Bias"
        case .moderateBias:
            return "Moderate Bias"
        case .highBias:
            return "High Bias"
        case .balanced:
            return "Balanced"
        case .unclear:
            return "Unclear"
        }
    }
}
