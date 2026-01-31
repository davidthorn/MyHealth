//
//  RestingHeartRateSummary.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct RestingHeartRateSummary: Codable, Hashable, Sendable {
    public let latest: RestingHeartRateDay?
    public let previous: [RestingHeartRateDay]

    public init(latest: RestingHeartRateDay?, previous: [RestingHeartRateDay]) {
        self.latest = latest
        self.previous = previous
    }
}
