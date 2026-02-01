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

    public init(types: [NutritionType]) {
        self.types = types
    }
}
