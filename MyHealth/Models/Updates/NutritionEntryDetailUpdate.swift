//
//  NutritionEntryDetailUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct NutritionEntryDetailUpdate {
    public let sample: NutritionSample

    public init(sample: NutritionSample) {
        self.sample = sample
    }
}
