//
//  HealthStoreActivitySummaryReading.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

public protocol HealthStoreActivitySummaryReading {
    var healthStore: HKHealthStore { get }
}

public extension HealthStoreActivitySummaryReading where Self: HealthStoreSampleQuerying {
    func fetchActivitySummaries(days: Int) async -> [ActivityRingsDay] {
        let safeDays = max(days, 1)
        let calendar = Calendar.current
        let endDate = Date()
        let anchorDate = startOfDay(for: endDate, calendar: calendar)
        let window = dayRangeWindow(days: safeDays, endingAt: endDate, calendar: calendar)
        let descriptor = HKActivitySummaryQueryDescriptor(predicate: nil)
        do {
            let summaries = try await descriptor.result(for: healthStore)
            let days = summaries.compactMap { $0.activityRingsDay(calendar: calendar) }
            let filtered = days.filter { $0.date >= window.start && $0.date <= anchorDate }
            return filtered.sorted { $0.date > $1.date }
        } catch {
            return []
        }
    }
    
    func fetchActivitySummaryDay(date: Date) async -> ActivityRingsDay {
        let calendar = Calendar.current
        let window = dayWindow(for: date, calendar: calendar)
        var components = calendar.dateComponents([.year, .month, .day], from: window.start)
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
            date: window.start,
            moveValue: 0,
            moveGoal: 0,
            exerciseMinutes: 0,
            exerciseGoal: 0,
            standHours: 0,
            standGoal: 0
        )
    }
}
