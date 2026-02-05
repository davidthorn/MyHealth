//
//  SleepEntry.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct SleepEntry: Codable, Hashable, Sendable, Identifiable {
    public let id: UUID
    public let startDate: Date
    public let endDate: Date
    public let category: SleepEntryCategory
    public let isUserEntered: Bool
    public let sourceName: String?
    public let deviceName: String?

    public init(
        id: UUID,
        startDate: Date,
        endDate: Date,
        category: SleepEntryCategory,
        isUserEntered: Bool,
        sourceName: String?,
        deviceName: String?
    ) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.category = category
        self.isUserEntered = isUserEntered
        self.sourceName = sourceName
        self.deviceName = deviceName
    }

    public var durationSeconds: TimeInterval {
        max(endDate.timeIntervalSince(startDate), 0)
    }
}
