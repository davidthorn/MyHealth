//
//  DashboardUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct DashboardUpdate: Sendable {
    public let title: String

    public init(title: String) {
        self.title = title
    }
}
