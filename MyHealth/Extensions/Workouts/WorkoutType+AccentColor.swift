//
//  WorkoutType+AccentColor.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public extension WorkoutType {
    var accentColor: Color {
        switch self {
        case .running:
            return Color(red: 0.90, green: 0.32, blue: 0.26)
        case .walking:
            return Color(red: 0.18, green: 0.63, blue: 0.47)
        case .cycling:
            return Color(red: 0.20, green: 0.45, blue: 0.78)
        case .swimming:
            return Color(red: 0.14, green: 0.62, blue: 0.69)
        case .yoga:
            return Color(red: 0.78, green: 0.42, blue: 0.63)
        case .strength:
            return Color(red: 0.55, green: 0.28, blue: 0.63)
        case .other:
            return Color(red: 0.45, green: 0.45, blue: 0.52)
        @unknown default:
            return Color(red: 0.45, green: 0.45, blue: 0.52)
        }
    }
}
