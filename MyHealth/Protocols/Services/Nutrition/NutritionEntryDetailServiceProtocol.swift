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
    func delete(id: UUID) async throws
}
