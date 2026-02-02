//
//  NutritionServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol NutritionServiceProtocol {
    func updates() -> AsyncStream<NutritionUpdate>
    func nutritionSummary(window: NutritionWindow) -> AsyncStream<NutritionWindowSummary?>
}
