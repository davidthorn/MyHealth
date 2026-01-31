//
//  StandHoursSummaryServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol StandHoursSummaryServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates() -> AsyncStream<StandHoursSummaryUpdate>
}
