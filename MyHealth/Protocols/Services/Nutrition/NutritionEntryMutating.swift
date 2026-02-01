//
//  NutritionEntryMutating.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol NutritionEntryMutating {
    func save(sample: NutritionSample) async throws
    func delete(id: UUID) async throws
}
