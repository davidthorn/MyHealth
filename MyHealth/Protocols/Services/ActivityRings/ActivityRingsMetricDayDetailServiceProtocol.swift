//
//  ActivityRingsMetricDayDetailServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol ActivityRingsMetricDayDetailServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates(for date: Date) -> AsyncStream<ActivityRingsMetricDayDetailUpdate>
}
