//
//  HeartRateSummary.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct HeartRateSummary: Codable, Hashable, Sendable {
    public let latest: HeartRateReading?
    public let previous: [HeartRateReading]

    public init(latest: HeartRateReading?, previous: [HeartRateReading]) {
        self.latest = latest
        self.previous = previous
    }
}
