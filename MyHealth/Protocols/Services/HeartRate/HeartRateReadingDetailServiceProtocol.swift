//
//  HeartRateReadingDetailServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol HeartRateReadingDetailServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates(for id: UUID) -> AsyncStream<HeartRateReadingDetailUpdate>
}
