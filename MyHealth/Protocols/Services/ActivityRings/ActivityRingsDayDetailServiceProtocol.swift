//
//  ActivityRingsDayDetailServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol ActivityRingsDayDetailServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates(for date: Date) -> AsyncStream<ActivityRingsDayDetailUpdate>
}
