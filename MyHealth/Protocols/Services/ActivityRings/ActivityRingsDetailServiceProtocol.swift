//
//  ActivityRingsDetailServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol ActivityRingsDetailServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates() -> AsyncStream<ActivityRingsDetailUpdate>
}
