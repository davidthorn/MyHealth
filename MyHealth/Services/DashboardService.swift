//
//  DashboardService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

@MainActor
public final class DashboardService: DashboardServiceProtocol {
    public init() {}

    public func updates() -> AsyncStream<DashboardUpdate> {
        AsyncStream { continuation in
            continuation.yield(DashboardUpdate(title: "Dashboard"))
            continuation.finish()
        }
    }
}
