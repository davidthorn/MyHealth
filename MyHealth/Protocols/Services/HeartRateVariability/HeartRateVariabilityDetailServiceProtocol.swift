//
//  HeartRateVariabilityDetailServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HeartRateVariabilityDetailServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates(window: HeartRateVariabilityWindow) -> AsyncStream<HeartRateVariabilityDetailUpdate>
}
