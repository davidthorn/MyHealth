//
//  BloodOxygenReading.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct BloodOxygenReading: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID
    public let percent: Double
    public let startDate: Date
    public let endDate: Date
    public let sourceName: String?
    public let deviceName: String?
    public let wasUserEntered: Bool?

    public init(
        id: UUID = UUID(),
        percent: Double,
        startDate: Date,
        endDate: Date,
        sourceName: String? = nil,
        deviceName: String? = nil,
        wasUserEntered: Bool? = nil
    ) {
        self.id = id
        self.percent = percent
        self.startDate = startDate
        self.endDate = endDate
        self.sourceName = sourceName
        self.deviceName = deviceName
        self.wasUserEntered = wasUserEntered
    }
}
