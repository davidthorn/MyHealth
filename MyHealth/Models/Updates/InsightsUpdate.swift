//
//  InsightsUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct InsightsUpdate: Sendable {
    public let title: String

    public init(title: String) {
        self.title = title
    }
}
