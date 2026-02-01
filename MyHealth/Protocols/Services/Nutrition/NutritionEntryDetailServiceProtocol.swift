//
//  NutritionEntryDetailServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol NutritionEntryDetailServiceProtocol {
    func updates(for sample: NutritionSample) -> AsyncStream<NutritionEntryDetailUpdate>
    func save(sample: NutritionSample) async throws
    func update(original: NutritionSample, updated: NutritionSample) async throws
    func delete(sample: NutritionSample) async throws
}
