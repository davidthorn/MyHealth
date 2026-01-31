//
//  CaloriesDetailUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct CaloriesDetailUpdate: Sendable {
    public let summary: CaloriesSummary

    public init(summary: CaloriesSummary) {
        self.summary = summary
    }
}
