//
//  MetricsUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct MetricsUpdate: Sendable {
    public let title: String

    public init(title: String) {
        self.title = title
    }
}
