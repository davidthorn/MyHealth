//
//  SleepDetailUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct SleepDetailUpdate: Sendable {
    public let summary: SleepSummary

    public init(summary: SleepSummary) {
        self.summary = summary
    }
}
