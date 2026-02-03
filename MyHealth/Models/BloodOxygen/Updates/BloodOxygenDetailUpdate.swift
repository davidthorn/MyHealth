//
//  BloodOxygenDetailUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct BloodOxygenDetailUpdate: Sendable {
    public let readings: [BloodOxygenReading]

    public init(readings: [BloodOxygenReading]) {
        self.readings = readings
    }
}
