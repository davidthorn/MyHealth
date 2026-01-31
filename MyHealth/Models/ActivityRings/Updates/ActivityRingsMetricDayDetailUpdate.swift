//
//  ActivityRingsMetricDayDetailUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct ActivityRingsMetricDayDetailUpdate: Sendable {
    public let day: ActivityRingsDay

    public init(day: ActivityRingsDay) {
        self.day = day
    }
}
