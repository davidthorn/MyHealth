//
//  StepsSummaryServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol StepsSummaryServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates() -> AsyncStream<StepsSummaryUpdate>
}
