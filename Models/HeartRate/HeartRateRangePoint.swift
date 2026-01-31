//
//  HeartRateRangePoint.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct HeartRateRangePoint: Codable, Hashable, Sendable, Identifiable {
    public let date: Date
    public let bpm: Double

    public var id: Date { date }

    public init(date: Date, bpm: Double) {
        self.date = date
        self.bpm = bpm
    }
}
