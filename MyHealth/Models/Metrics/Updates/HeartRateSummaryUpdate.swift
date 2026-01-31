//
//  HeartRateSummaryUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct HeartRateSummaryUpdate: Sendable {
    public let summary: HeartRateSummary

    public init(summary: HeartRateSummary) {
        self.summary = summary
    }
}
