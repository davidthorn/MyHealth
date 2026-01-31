//
//  SleepDetailServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol SleepDetailServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates() -> AsyncStream<SleepDetailUpdate>
}
