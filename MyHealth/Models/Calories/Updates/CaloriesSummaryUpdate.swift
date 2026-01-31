//
//  CaloriesSummaryUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct CaloriesSummaryUpdate: Sendable {
    public let summary: CaloriesSummary

    public init(summary: CaloriesSummary) {
        self.summary = summary
    }
}
