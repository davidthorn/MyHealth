//
//  InsightsUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct InsightsUpdate: Sendable {
    public let title: String
    public let isAuthorized: Bool
    public let insights: [InsightItem]

    public init(title: String, isAuthorized: Bool, insights: [InsightItem]) {
        self.title = title
        self.isAuthorized = isAuthorized
        self.insights = insights
    }
}
