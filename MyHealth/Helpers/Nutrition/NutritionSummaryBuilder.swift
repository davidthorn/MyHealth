//
//  NutritionSummaryBuilder.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

public struct NutritionSummaryBuilder {
    public init() {}

    public func todaySummary(using adapter: HealthKitAdapterProtocol) async -> NutritionDaySummary? {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else { return nil }

        var totals: [NutritionDayTotal] = []
        for type in adapter.nutritionTypes() {
            let samples = await adapter.nutritionSamples(type: type, start: startDate, end: endDate)
            let totalValue = samples.reduce(0) { $0 + $1.value }
            guard totalValue > 0 else { continue }
            totals.append(NutritionDayTotal(type: type, value: totalValue, unit: type.unit))
        }

        guard !totals.isEmpty else { return nil }
        let sorted = totals.sorted { $0.value > $1.value }
        return NutritionDaySummary(date: startDate, totals: sorted)
    }
}
