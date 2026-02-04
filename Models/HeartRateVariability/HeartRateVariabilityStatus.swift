//
//  HeartRateVariabilityStatus.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public enum HeartRateVariabilityStatus: String, Codable, Hashable, Sendable {
    case low
    case normal
    case high

    public var title: String {
        switch self {
        case .low: return "Low"
        case .normal: return "Normal"
        case .high: return "High"
        }
    }
}
