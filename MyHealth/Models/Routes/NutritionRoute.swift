//
//  NutritionRoute.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public enum NutritionRoute: Hashable {
    case type(NutritionType)
    case entry(NutritionSample)
    case newEntry

    public init(type: NutritionType) {
        self = .type(type)
    }

    public init(entry: NutritionSample) {
        self = .entry(entry)
    }

    public init() {
        self = .newEntry
    }
}
