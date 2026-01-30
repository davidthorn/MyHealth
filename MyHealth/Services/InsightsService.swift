//
//  InsightsService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

@MainActor
public final class InsightsService: InsightsServiceProtocol {
    public init() {}

    public func updates() -> AsyncStream<InsightsUpdate> {
        AsyncStream { continuation in
            continuation.yield(InsightsUpdate(title: "Insights"))
            continuation.finish()
        }
    }
}
