//
//  StepsSummary.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct StepsSummary: Codable, Hashable, Sendable {
    public let latest: StepsDay?
    public let previous: [StepsDay]

    public init(latest: StepsDay?, previous: [StepsDay]) {
        self.latest = latest
        self.previous = previous
    }
}
