//
//  SleepTrainingBalanceStatus.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum SleepTrainingBalanceStatus: String, Hashable, Sendable, Identifiable {
    case balanced
    case underRecovered
    case wellRecovered
    case unclear

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .balanced:
            return "Balanced"
        case .underRecovered:
            return "Under‑Recovered"
        case .wellRecovered:
            return "Well‑Recovered"
        case .unclear:
            return "Unclear"
        }
    }
}
