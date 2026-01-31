//
//  RestingHeartRateSummaryServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol RestingHeartRateSummaryServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates() -> AsyncStream<RestingHeartRateSummaryUpdate>
}
