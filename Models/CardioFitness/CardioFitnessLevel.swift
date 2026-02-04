//
//  CardioFitnessLevel.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public enum CardioFitnessLevel: String, Codable, Hashable, Sendable {
    case low
    case belowAverage
    case average
    case aboveAverage
    case high

    public var title: String {
        switch self {
        case .low: return "Low"
        case .belowAverage: return "Below Avg"
        case .average: return "Average"
        case .aboveAverage: return "Above Avg"
        case .high: return "High"
        }
    }
}
