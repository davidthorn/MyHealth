//
//  WorkoutSplit+Formatting.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public extension WorkoutSplit {
    var formattedDurationText: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: durationSeconds) ?? "—"
    }

    var formattedPaceText: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        let pace = formatter.string(from: paceSecondsPerKilometer) ?? "—"
        return "\(pace) /km"
    }

    var formattedHeartRateText: String? {
        guard let averageHeartRateBpm else { return nil }
        return "\(Int(averageHeartRateBpm.rounded())) bpm"
    }
}
