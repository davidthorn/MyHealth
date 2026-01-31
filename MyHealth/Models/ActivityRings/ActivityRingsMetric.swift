//
//  ActivityRingsMetric.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum ActivityRingsMetric: String, CaseIterable, Hashable, Sendable {
    case move
    case exercise
    case stand

    public var title: String {
        switch self {
        case .move:
            return "Move"
        case .exercise:
            return "Exercise"
        case .stand:
            return "Stand"
        }
    }

    public var unit: String {
        switch self {
        case .move:
            return "kcal"
        case .exercise:
            return "min"
        case .stand:
            return "hr"
        }
    }

    public var systemImage: String {
        switch self {
        case .move:
            return "flame"
        case .exercise:
            return "figure.run"
        case .stand:
            return "figure.stand"
        }
    }
}
