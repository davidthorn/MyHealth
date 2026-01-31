//
//  SleepSummary.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct SleepSummary: Codable, Hashable, Sendable {
    public let latest: SleepDay?
    public let previous: [SleepDay]

    public init(latest: SleepDay?, previous: [SleepDay]) {
        self.latest = latest
        self.previous = previous
    }
}
