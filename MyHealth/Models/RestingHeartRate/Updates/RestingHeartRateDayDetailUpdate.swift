//
//  RestingHeartRateDayDetailUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct RestingHeartRateDayDetailUpdate: Sendable {
    public let readings: [RestingHeartRateReading]

    public init(readings: [RestingHeartRateReading]) {
        self.readings = readings
    }
}
