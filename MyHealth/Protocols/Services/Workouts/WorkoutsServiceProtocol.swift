//
//  WorkoutsServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol WorkoutsServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates() -> AsyncStream<WorkoutsUpdate>
}
