//
//  NutritionWindowSummary+Label.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public extension NutritionWindowSummary {
    var windowLabel: String {
        let start = startDate.formatted(date: .abbreviated, time: .omitted)
        let end = endDate.formatted(date: .abbreviated, time: .omitted)
        if window == .today {
            return start
        }
        return "\(start) – \(end)"
    }
}
