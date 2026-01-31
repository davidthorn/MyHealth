//
//  CaloriesSummaryServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol CaloriesSummaryServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates() -> AsyncStream<CaloriesSummaryUpdate>
}
