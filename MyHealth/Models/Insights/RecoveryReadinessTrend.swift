//
//  RecoveryReadinessTrend.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum RecoveryReadinessTrend: String, Hashable, Sendable, Identifiable {
    case up
    case down
    case steady
    case unknown

    public var id: String { rawValue }

    public var symbolName: String {
        switch self {
        case .up:
            return "arrow.up"
        case .down:
            return "arrow.down"
        case .steady:
            return "arrow.right"
        case .unknown:
            return "questionmark"
        }
    }

    public var label: String {
        switch self {
        case .up:
            return "Up"
        case .down:
            return "Down"
        case .steady:
            return "Steady"
        case .unknown:
            return "No Data"
        }
    }
}
