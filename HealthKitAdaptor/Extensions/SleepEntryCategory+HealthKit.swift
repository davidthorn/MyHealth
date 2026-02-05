//
//  SleepEntryCategory+HealthKit.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import HealthKit
import Models

extension SleepEntryCategory {
    init?(healthKitValue: HKCategoryValueSleepAnalysis) {
        switch healthKitValue {
        case .inBed:
            self = .inBed
        case .asleepUnspecified:
            self = .asleep
        case .asleepCore:
            self = .asleepCore
        case .asleepDeep:
            self = .asleepDeep
        case .asleepREM:
            self = .asleepREM
        case .awake:
            self = .awake
        @unknown default:
            return nil
        }
    }

    var healthKitValue: HKCategoryValueSleepAnalysis {
        switch self {
        case .inBed:
            return .inBed
        case .asleep:
            return .asleepUnspecified
        case .asleepCore:
            return .asleepCore
        case .asleepDeep:
            return .asleepDeep
        case .asleepREM:
            return .asleepREM
        case .awake:
            return .awake
        }
    }
}
