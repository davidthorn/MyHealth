//
//  WorkoutRecoveryBalanceStatus.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum WorkoutRecoveryBalanceStatus: String, Hashable, Sendable, Identifiable {
    case balanced
    case overreaching
    case readyForMore
    case unclear

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .balanced:
            return "Balanced"
        case .overreaching:
            return "Overreaching"
        case .readyForMore:
            return "Ready for More"
        case .unclear:
            return "Unclear"
        }
    }
}
