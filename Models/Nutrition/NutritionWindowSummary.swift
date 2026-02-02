//
//  NutritionWindowSummary.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct NutritionWindowSummary: Codable, Hashable, Sendable {
    public let window: NutritionWindow
    public let startDate: Date
    public let endDate: Date
    public let totals: [NutritionDayTotal]

    public init(window: NutritionWindow, startDate: Date, endDate: Date, totals: [NutritionDayTotal]) {
        self.window = window
        self.startDate = startDate
        self.endDate = endDate
        self.totals = totals
    }
}
