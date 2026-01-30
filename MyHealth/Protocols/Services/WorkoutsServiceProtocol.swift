//
//  WorkoutsServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol WorkoutsServiceProtocol {
    func updates() -> AsyncStream<WorkoutsUpdate>
}
