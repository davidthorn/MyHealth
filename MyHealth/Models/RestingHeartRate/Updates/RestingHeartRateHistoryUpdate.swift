//
//  RestingHeartRateHistoryUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct RestingHeartRateHistoryUpdate: Sendable {
    public let summary: RestingHeartRateSummary

    public init(summary: RestingHeartRateSummary) {
        self.summary = summary
    }
}
