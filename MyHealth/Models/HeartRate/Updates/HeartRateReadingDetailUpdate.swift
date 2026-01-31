//
//  HeartRateReadingDetailUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct HeartRateReadingDetailUpdate: Sendable {
    public let reading: HeartRateReading

    public init(reading: HeartRateReading) {
        self.reading = reading
    }
}
