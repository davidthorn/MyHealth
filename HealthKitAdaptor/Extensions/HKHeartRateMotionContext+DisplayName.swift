//
//  HKHeartRateMotionContext+DisplayName.swift
//  MyHealth
//
//  Created by Codex.
//

import HealthKit

extension HKHeartRateMotionContext {
    internal var displayName: String {
        switch self {
        case .active:
            return "Active"
        case .sedentary:
            return "Sedentary"
        case .notSet:
            return "Not Set"
        @unknown default:
            return "Unknown"
        }
    }
}
