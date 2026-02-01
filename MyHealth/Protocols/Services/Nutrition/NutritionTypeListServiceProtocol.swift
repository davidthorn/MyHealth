//
//  NutritionTypeListServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol NutritionTypeListServiceProtocol {
    func requestAuthorization(type: NutritionType) async -> Bool
    func updates(for type: NutritionType) -> AsyncStream<NutritionTypeListUpdate>
}
