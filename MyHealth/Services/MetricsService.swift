//
//  MetricsService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

@MainActor
public final class MetricsService: MetricsServiceProtocol {
    public init() {}

    public func updates() -> AsyncStream<MetricsUpdate> {
        AsyncStream { continuation in
            continuation.yield(MetricsUpdate(title: "Metrics"))
            continuation.finish()
        }
    }
}
