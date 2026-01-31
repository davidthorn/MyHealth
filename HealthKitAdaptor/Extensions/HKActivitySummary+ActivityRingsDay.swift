//
//  HKActivitySummary+ActivityRingsDay.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

extension HKActivitySummary {
    func activityRingsDay(calendar: Calendar = .current) -> ActivityRingsDay? {
        let components = dateComponents(for: calendar)
        guard let date = calendar.date(from: components) else { return nil }
        let moveValue = activeEnergyBurned.doubleValue(for: .kilocalorie())
        let moveGoal = activeEnergyBurnedGoal.doubleValue(for: .kilocalorie())
        let exerciseMinutes = appleExerciseTime.doubleValue(for: .minute())
        let exerciseGoal = appleExerciseTimeGoal.doubleValue(for: .minute())
        let standHours = appleStandHours.doubleValue(for: .count())
        let standGoal = appleStandHoursGoal.doubleValue(for: .count())
        return ActivityRingsDay(
            date: calendar.startOfDay(for: date),
            moveValue: moveValue,
            moveGoal: moveGoal,
            exerciseMinutes: exerciseMinutes,
            exerciseGoal: exerciseGoal,
            standHours: standHours,
            standGoal: standGoal
        )
    }
}
