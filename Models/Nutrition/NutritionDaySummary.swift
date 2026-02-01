//
//  NutritionDaySummary.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct NutritionDaySummary: Codable, Hashable, Sendable {
    public let date: Date
    public let totals: [NutritionDayTotal]

    public init(date: Date, totals: [NutritionDayTotal]) {
        self.date = date
        self.totals = totals
    }
}
