//
//  NutritionTypeListServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol NutritionTypeListServiceProtocol {
    func updates(for type: NutritionType) -> AsyncStream<NutritionTypeListUpdate>
}
