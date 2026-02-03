//
//  BloodOxygenDetailServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol BloodOxygenDetailServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates(window: BloodOxygenWindow) -> AsyncStream<BloodOxygenDetailUpdate>
}
