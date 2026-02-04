//
//  InsightsServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol InsightsServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates() -> AsyncStream<InsightsUpdate>
}
