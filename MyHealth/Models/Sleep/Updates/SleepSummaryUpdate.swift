//
//  SleepSummaryUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct SleepSummaryUpdate: Sendable {
    public let summary: SleepSummary

    public init(summary: SleepSummary) {
        self.summary = summary
    }
}
