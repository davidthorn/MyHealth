//
//  CardioFitnessTrendStatus.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum CardioFitnessTrendStatus: String, Hashable, Sendable, Identifiable {
    case rising
    case steady
    case declining
    case unclear

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .rising:
            return "Rising"
        case .steady:
            return "Steady"
        case .declining:
            return "Declining"
        case .unclear:
            return "Unclear"
        }
    }
}
