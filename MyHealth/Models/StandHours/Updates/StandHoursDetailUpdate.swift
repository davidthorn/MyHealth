//
//  StandHoursDetailUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct StandHoursDetailUpdate: Sendable {
    public let summary: StandHoursSummary

    public init(summary: StandHoursSummary) {
        self.summary = summary
    }
}
