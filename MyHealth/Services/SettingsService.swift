//
//  SettingsService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

@MainActor
public final class SettingsService: SettingsServiceProtocol {
    public init() {}

    public func updates() -> AsyncStream<SettingsUpdate> {
        AsyncStream { continuation in
            continuation.yield(SettingsUpdate(title: "Settings"))
            continuation.finish()
        }
    }
}
