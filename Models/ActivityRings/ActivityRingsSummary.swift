//
//  ActivityRingsSummary.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct ActivityRingsSummary: Codable, Hashable, Sendable {
    public let latest: ActivityRingsDay?
    public let previous: [ActivityRingsDay]

    public init(latest: ActivityRingsDay?, previous: [ActivityRingsDay]) {
        self.latest = latest
        self.previous = previous
    }
}
