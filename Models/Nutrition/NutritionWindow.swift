//
//  NutritionWindow.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum NutritionWindow: String, CaseIterable, Codable, Hashable, Identifiable, Sendable {
    case today
    case last3Days
    case last7Days
    case last14Days

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .today: return "Today"
        case .last3Days: return "3D"
        case .last7Days: return "7D"
        case .last14Days: return "14D"
        }
    }

    public var dayCount: Int {
        switch self {
        case .today: return 1
        case .last3Days: return 3
        case .last7Days: return 7
        case .last14Days: return 14
        }
    }

    public init() {
        self = .today
    }
}
