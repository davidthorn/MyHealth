//
//  HeartRateReading.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct HeartRateReading: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID
    public let bpm: Double
    public let date: Date
    public let startDate: Date
    public let endDate: Date
    public let sourceName: String?
    public let deviceName: String?
    public let wasUserEntered: Bool?
    public let motionContext: String?
    public let sensorLocation: String?

    public init(
        id: UUID = UUID(),
        bpm: Double,
        date: Date,
        startDate: Date,
        endDate: Date,
        sourceName: String? = nil,
        deviceName: String? = nil,
        wasUserEntered: Bool? = nil,
        motionContext: String? = nil,
        sensorLocation: String? = nil
    ) {
        self.id = id
        self.bpm = bpm
        self.date = date
        self.startDate = startDate
        self.endDate = endDate
        self.sourceName = sourceName
        self.deviceName = deviceName
        self.wasUserEntered = wasUserEntered
        self.motionContext = motionContext
        self.sensorLocation = sensorLocation
    }
}
