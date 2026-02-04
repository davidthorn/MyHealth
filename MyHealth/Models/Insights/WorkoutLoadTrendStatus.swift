//
//  WorkoutLoadTrendStatus.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum WorkoutLoadTrendStatus: String, Hashable, Sendable, Identifiable {
    case rampingUp
    case steady
    case tapering
    case unclear

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .rampingUp:
            return "Ramping Up"
        case .steady:
            return "Steady"
        case .tapering:
            return "Tapering"
        case .unclear:
            return "Unclear"
        }
    }
}
