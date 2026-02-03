//
//  ExerciseMinutesDetailUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct ExerciseMinutesDetailUpdate: Sendable {
    public let days: [ExerciseMinutesDayDetail]

    public init(days: [ExerciseMinutesDayDetail]) {
        self.days = days
    }
}
