//
//  StandHoursSummaryUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct StandHoursSummaryUpdate: Sendable {
    public let summary: StandHoursSummary

    public init(summary: StandHoursSummary) {
        self.summary = summary
    }
}
