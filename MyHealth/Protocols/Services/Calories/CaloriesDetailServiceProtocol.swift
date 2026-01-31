//
//  CaloriesDetailServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol CaloriesDetailServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates() -> AsyncStream<CaloriesDetailUpdate>
}
