//
//  StepsDetailServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol StepsDetailServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates() -> AsyncStream<StepsDetailUpdate>
}
