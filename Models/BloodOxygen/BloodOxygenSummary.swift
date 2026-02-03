//
//  BloodOxygenSummary.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct BloodOxygenSummary: Codable, Hashable, Sendable {
    public let latest: BloodOxygenReading?
    public let previous: [BloodOxygenReading]

    public init(latest: BloodOxygenReading?, previous: [BloodOxygenReading]) {
        self.latest = latest
        self.previous = previous
    }
}
