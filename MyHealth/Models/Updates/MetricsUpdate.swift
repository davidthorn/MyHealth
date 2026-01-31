//
//  MetricsUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct MetricsUpdate: Sendable {
    public let title: String
    public let restingHeartRateSummary: RestingHeartRateSummary?

    public init(title: String, restingHeartRateSummary: RestingHeartRateSummary?) {
        self.title = title
        self.restingHeartRateSummary = restingHeartRateSummary
    }
}
