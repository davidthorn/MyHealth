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

    public func windowSummary(using adapter: HealthKitAdapterProtocol, window: NutritionWindow) async -> NutritionWindowSummary? {
        let calendar = Calendar.current
        let endDate = calendar.startOfDay(for: Date()).addingTimeInterval(24 * 60 * 60)
        guard let startDate = calendar.date(byAdding: .day, value: -(window.dayCount - 1), to: calendar.startOfDay(for: Date())) else {
            return nil
        }

        var totals: [NutritionDayTotal] = []
        for type in adapter.nutritionTypes() {
            let totalValue = await adapter.nutritionTotal(type: type, start: startDate, end: endDate) ?? 0
            guard totalValue > 0 else { continue }
            totals.append(NutritionDayTotal(type: type, value: totalValue, unit: type.unit))
        }

        guard !totals.isEmpty else { return nil }
        let sorted = totals.sorted { $0.value > $1.value }
        return NutritionWindowSummary(window: window, startDate: startDate, endDate: endDate, totals: sorted)
    }
}
