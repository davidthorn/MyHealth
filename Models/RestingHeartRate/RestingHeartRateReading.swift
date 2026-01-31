//
//  RestingHeartRateReading.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct RestingHeartRateReading: Codable, Hashable, Sendable, Identifiable {
    public let id: UUID
    public let bpm: Double
    public let startDate: Date
    public let endDate: Date
    public let sourceName: String
    public let sourceBundleIdentifier: String
    public let deviceName: String?
    public let metadata: [String: String]

    public init(
        id: UUID,
        bpm: Double,
        startDate: Date,
        endDate: Date,
        sourceName: String,
        sourceBundleIdentifier: String,
        deviceName: String?,
        metadata: [String: String]
    ) {
        self.id = id
        self.bpm = bpm
        self.startDate = startDate
        self.endDate = endDate
        self.sourceName = sourceName
        self.sourceBundleIdentifier = sourceBundleIdentifier
        self.deviceName = deviceName
        self.metadata = metadata
    }
}
