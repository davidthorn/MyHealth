//
//  FlightsDetailServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol FlightsDetailServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates() -> AsyncStream<FlightsDetailUpdate>
}
