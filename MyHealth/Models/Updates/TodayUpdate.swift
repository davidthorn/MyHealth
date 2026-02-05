//
//  TodayUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct TodayUpdate: Sendable {
    public let title: String
    public let latestWorkout: TodayLatestWorkout?
    public let activityRingsDay: ActivityRingsDay?

    public init(title: String, latestWorkout: TodayLatestWorkout?, activityRingsDay: ActivityRingsDay?) {
        self.title = title
        self.latestWorkout = latestWorkout
        self.activityRingsDay = activityRingsDay
    }
}
