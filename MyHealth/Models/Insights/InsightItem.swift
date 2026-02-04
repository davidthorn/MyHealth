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
    public let activityHighlights: ActivityHighlightsInsight?
    public let workoutHighlights: WorkoutHighlightsInsight?
    public let recoveryReadiness: RecoveryReadinessInsight?

    public var id: InsightType { type }

    public init(
        type: InsightType,
        title: String,
        summary: String,
        detail: String,
        status: String,
        icon: String,
        activityHighlights: ActivityHighlightsInsight? = nil,
        workoutHighlights: WorkoutHighlightsInsight? = nil,
        recoveryReadiness: RecoveryReadinessInsight? = nil
    ) {
        self.type = type
        self.title = title
        self.summary = summary
        self.detail = detail
        self.status = status
        self.icon = icon
        self.activityHighlights = activityHighlights
        self.workoutHighlights = workoutHighlights
        self.recoveryReadiness = recoveryReadiness
    }
}
