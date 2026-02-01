//
//  NutritionServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol NutritionServiceProtocol {
    func updates() -> AsyncStream<NutritionUpdate>
}
