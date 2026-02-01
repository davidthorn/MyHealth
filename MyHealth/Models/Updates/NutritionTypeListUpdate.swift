//
//  NutritionTypeListUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct NutritionTypeListUpdate {
    public let type: NutritionType
    public let samples: [NutritionSample]

    public init(type: NutritionType, samples: [NutritionSample]) {
        self.type = type
        self.samples = samples
    }
}
