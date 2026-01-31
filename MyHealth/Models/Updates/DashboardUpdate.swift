//
//  DashboardUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct DashboardUpdate: Sendable {
    public let title: String
    public let latestWorkout: DashboardLatestWorkout?
    public let activityRingsDay: ActivityRingsDay?

    public init(title: String, latestWorkout: DashboardLatestWorkout?, activityRingsDay: ActivityRingsDay?) {
        self.title = title
        self.latestWorkout = latestWorkout
        self.activityRingsDay = activityRingsDay
    }
}
