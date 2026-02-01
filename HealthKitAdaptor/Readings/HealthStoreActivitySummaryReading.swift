//
//  HealthStoreActivitySummaryReading.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

@MainActor
internal protocol HealthStoreActivitySummaryReading {
    var healthStore: HKHealthStore { get }
}

@MainActor
extension HealthStoreActivitySummaryReading {
    public func fetchActivitySummaries(days: Int) async -> [ActivityRingsDay] {
        let safeDays = max(days, 1)
        let calendar = Calendar.current
        let endDate = Date()
        let anchorDate = calendar.startOfDay(for: endDate)
        guard let startDate = calendar.date(byAdding: .day, value: -(safeDays - 1), to: anchorDate) else {
            return []
        }
        let descriptor = HKActivitySummaryQueryDescriptor(predicate: nil)
        do {
            let summaries = try await descriptor.result(for: healthStore)
            let days = summaries.compactMap { $0.activityRingsDay(calendar: calendar) }
            let filtered = days.filter { $0.date >= startDate && $0.date <= anchorDate }
            return filtered.sorted { $0.date > $1.date }
        } catch {
            return []
        }
    }
    
    public func fetchActivitySummaryDay(date: Date) async -> ActivityRingsDay {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        var components = calendar.dateComponents([.year, .month, .day], from: startDate)
        components.calendar = calendar
        let predicate = HKQuery.predicateForActivitySummary(with: components)
        let descriptor = HKActivitySummaryQueryDescriptor(predicate: predicate)
        do {
            let summaries = try await descriptor.result(for: healthStore)
            if let summary = summaries.first?.activityRingsDay(calendar: calendar) {
                return summary
            }
        } catch {
            // fall through to default
        }
        return ActivityRingsDay(
            date: startDate,
            moveValue: 0,
            moveGoal: 0,
            exerciseMinutes: 0,
            exerciseGoal: 0,
            standHours: 0,
            standGoal: 0
        )
    }
}
