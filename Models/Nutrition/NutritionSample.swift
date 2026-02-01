//
//  NutritionSample.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct NutritionSample: Codable, Hashable, Identifiable {
    public let id: UUID
    public let type: NutritionType
    public let date: Date
    public let value: Double
    public let unit: String

    public init(
        id: UUID = UUID(),
        type: NutritionType,
        date: Date,
        value: Double,
        unit: String
    ) {
        self.id = id
        self.type = type
        self.date = date
        self.value = value
        self.unit = unit
    }
}
