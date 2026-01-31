//
//  StandHoursSummary.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct StandHoursSummary: Codable, Hashable, Sendable {
    public let latest: StandHourDay?
    public let previous: [StandHourDay]

    public init(latest: StandHourDay?, previous: [StandHourDay]) {
        self.latest = latest
        self.previous = previous
    }
}
