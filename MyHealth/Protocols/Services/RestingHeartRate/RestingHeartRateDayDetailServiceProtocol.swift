//
//  RestingHeartRateDayDetailServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol RestingHeartRateDayDetailServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates(for date: Date) -> AsyncStream<RestingHeartRateDayDetailUpdate>
    func rangeUpdates(start: Date, end: Date) -> AsyncStream<[HeartRateReading]>
}
