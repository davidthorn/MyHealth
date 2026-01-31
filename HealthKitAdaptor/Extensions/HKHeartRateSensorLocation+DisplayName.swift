//
//  HKHeartRateSensorLocation+DisplayName.swift
//  MyHealth
//
//  Created by Codex.
//

import HealthKit

extension HKHeartRateSensorLocation {
    internal var displayName: String {
        switch self {
        case .other:
            return "Other"
        case .chest:
            return "Chest"
        case .wrist:
            return "Wrist"
        case .finger:
            return "Finger"
        case .hand:
            return "Hand"
        case .earLobe:
            return "Ear Lobe"
        case .foot:
            return "Foot"
        @unknown default:
            return "Unknown"
        }
    }
}
