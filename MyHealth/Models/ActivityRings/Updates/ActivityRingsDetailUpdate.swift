//
//  ActivityRingsDetailUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct ActivityRingsDetailUpdate: Sendable {
    public let summary: ActivityRingsSummary

    public init(summary: ActivityRingsSummary) {
        self.summary = summary
    }
}
