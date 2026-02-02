//
//  MetricsServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol MetricsServiceProtocol {
    func updates() -> AsyncStream<MetricsUpdate>
    func nutritionSummary(window: NutritionWindow) -> AsyncStream<NutritionWindowSummary?>
}
