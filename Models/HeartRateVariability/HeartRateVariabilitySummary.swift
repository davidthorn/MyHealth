//
//  HeartRateVariabilitySummary.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct HeartRateVariabilitySummary: Codable, Hashable, Sendable {
    public let latest: HeartRateVariabilityReading?
    public let previous: [HeartRateVariabilityReading]

    public init(latest: HeartRateVariabilityReading?, previous: [HeartRateVariabilityReading]) {
        self.latest = latest
        self.previous = previous
    }
}
