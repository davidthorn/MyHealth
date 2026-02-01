//
//  NutritionDayTotal.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct NutritionDayTotal: Codable, Hashable, Identifiable, Sendable {
    public let id: String
    public let type: NutritionType
    public let value: Double
    public let unit: String

    public init(type: NutritionType, value: Double, unit: String) {
        self.id = type.rawValue
        self.type = type
        self.value = value
        self.unit = unit
    }
}
