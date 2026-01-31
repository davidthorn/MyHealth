//
//  SleepSummaryServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol SleepSummaryServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates() -> AsyncStream<SleepSummaryUpdate>
}
