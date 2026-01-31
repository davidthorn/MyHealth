//
//  HeartRateSummaryServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol HeartRateSummaryServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates() -> AsyncStream<HeartRateSummaryUpdate>
}
