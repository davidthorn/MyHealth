//
//  StandHoursDetailServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol StandHoursDetailServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates() -> AsyncStream<StandHoursDetailUpdate>
}
