//
//  FlightsSummary.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct FlightsSummary: Codable, Hashable, Sendable {
    public let latest: FlightsDay?
    public let previous: [FlightsDay]

    public init(latest: FlightsDay?, previous: [FlightsDay]) {
        self.latest = latest
        self.previous = previous
    }
}
