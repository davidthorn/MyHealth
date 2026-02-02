//
//  ActivityRingsDay+Progress.swift
//  MyHealth
//
//  Created by Codex.
//

import Models

public extension ActivityRingsDay {
    var closedRingsCount: Int {
        [
            moveValue >= moveGoal,
            exerciseMinutes >= exerciseGoal,
            standHours >= standGoal
        ]
        .filter { $0 }
        .count
    }

    var closedRingsText: String {
        "Closed \(closedRingsCount) ring" + (closedRingsCount == 1 ? "" : "s")
    }
}
