//
//  HeartRateVariabilityReading.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct HeartRateVariabilityReading: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID
    public let milliseconds: Double
    public let startDate: Date
    public let endDate: Date
    public let sourceName: String?
    public let deviceName: String?
    public let wasUserEntered: Bool?

    public init(
        id: UUID = UUID(),
        milliseconds: Double,
        startDate: Date,
        endDate: Date,
        sourceName: String? = nil,
        deviceName: String? = nil,
        wasUserEntered: Bool? = nil
    ) {
        self.id = id
        self.milliseconds = milliseconds
        self.startDate = startDate
        self.endDate = endDate
        self.sourceName = sourceName
        self.deviceName = deviceName
        self.wasUserEntered = wasUserEntered
    }
}
