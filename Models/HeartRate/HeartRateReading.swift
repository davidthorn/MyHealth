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

    public init(id: UUID = UUID(), bpm: Double, date: Date) {
        self.id = id
        self.bpm = bpm
        self.date = date
    }
}
