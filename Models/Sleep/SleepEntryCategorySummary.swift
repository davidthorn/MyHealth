//
//  SleepEntryCategorySummary.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct SleepEntryCategorySummary: Codable, Hashable, Sendable, Identifiable {
    public let category: SleepEntryCategory
    public let durationSeconds: TimeInterval

    public var id: String { category.id }

    public init(category: SleepEntryCategory, durationSeconds: TimeInterval) {
        self.category = category
        self.durationSeconds = durationSeconds
    }
}
