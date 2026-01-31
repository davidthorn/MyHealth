//
//  FlightsDetailUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct FlightsDetailUpdate: Sendable {
    public let summary: FlightsSummary

    public init(summary: FlightsSummary) {
        self.summary = summary
    }
}
