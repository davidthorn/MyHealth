//
//  HealthStoreExerciseMinutesReading.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

public protocol HealthStoreExerciseMinutesReading {
    var healthStore: HKHealthStore { get }
}

public extension HealthStoreExerciseMinutesReading where Self: HealthStoreSampleQuerying {
    func fetchExerciseMinutes(days: Int) async -> [ExerciseMinutesDay] {
        guard let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else { return [] }
        return await fetchDailyCumulativeSum(
            quantityType: exerciseType,
            unit: .minute(),
            days: days
        ) { date, value in
            ExerciseMinutesDay(date: date, minutes: value)
        }
    }
}
