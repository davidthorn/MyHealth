//
//  NutritionUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct NutritionUpdate {
    public let types: [NutritionType]
    public let summary: NutritionDaySummary?

    public init(types: [NutritionType], summary: NutritionDaySummary?) {
        self.types = types
        self.summary = summary
    }
}
