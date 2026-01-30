//
//  InsightsServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol InsightsServiceProtocol {
    func updates() -> AsyncStream<InsightsUpdate>
}
