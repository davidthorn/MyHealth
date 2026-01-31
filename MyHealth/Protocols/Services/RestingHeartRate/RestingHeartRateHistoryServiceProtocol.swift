//
//  RestingHeartRateHistoryServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol RestingHeartRateHistoryServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates() -> AsyncStream<RestingHeartRateHistoryUpdate>
}
