//
//  StepsSummaryUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct StepsSummaryUpdate: Sendable {
    public let summary: StepsSummary

    public init(summary: StepsSummary) {
        self.summary = summary
    }
}
