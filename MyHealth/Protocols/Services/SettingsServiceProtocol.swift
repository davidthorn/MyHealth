//
//  SettingsServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol SettingsServiceProtocol {
    func updates() -> AsyncStream<SettingsUpdate>
}
