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
    public let summary: NutritionWindowSummary?

    public init(types: [NutritionType], summary: NutritionWindowSummary?) {
        self.types = types
        self.summary = summary
    }
}
