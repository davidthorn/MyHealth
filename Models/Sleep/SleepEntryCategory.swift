//
//  SleepEntryCategory.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum SleepEntryCategory: String, CaseIterable, Codable, Hashable, Identifiable, Sendable {
    case inBed
    case asleep
    case asleepCore
    case asleepDeep
    case asleepREM
    case awake

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .inBed:
            return "In Bed"
        case .asleep:
            return "Asleep"
        case .asleepCore:
            return "Core Sleep"
        case .asleepDeep:
            return "Deep Sleep"
        case .asleepREM:
            return "REM Sleep"
        case .awake:
            return "Awake"
        }
    }

    public init() {
        self = .asleep
    }
}
