//
//  RestingHeartRateSummaryUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct RestingHeartRateSummaryUpdate: Sendable {
    public let summary: RestingHeartRateSummary

    public init(summary: RestingHeartRateSummary) {
        self.summary = summary
    }
}
