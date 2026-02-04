//
//  RecoveryReadinessStatus.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum RecoveryReadinessStatus: String, Hashable, Sendable, Identifiable {
    case ready
    case steady
    case strained
    case unclear

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .ready:
            return "Ready"
        case .steady:
            return "Steady"
        case .strained:
            return "Strained"
        case .unclear:
            return "Unclear"
        }
    }
}
