//
//  InsightItem.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct InsightItem: Hashable, Sendable, Identifiable {
    public let type: InsightType
    public let title: String
    public let summary: String
    public let detail: String
    public let status: String
    public let icon: String

    public var id: InsightType { type }

    public init(
        type: InsightType,
        title: String,
        summary: String,
        detail: String,
        status: String,
        icon: String
    ) {
        self.type = type
        self.title = title
        self.summary = summary
        self.detail = detail
        self.status = status
        self.icon = icon
    }
}
