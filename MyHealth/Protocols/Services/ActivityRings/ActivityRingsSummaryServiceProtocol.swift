//
//  ActivityRingsSummaryServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol ActivityRingsSummaryServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates() -> AsyncStream<ActivityRingsSummaryUpdate>
}
