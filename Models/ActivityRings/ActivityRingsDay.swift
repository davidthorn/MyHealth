//
//  ActivityRingsDay.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct ActivityRingsDay: Codable, Hashable, Sendable, Identifiable {
    public let date: Date
    public let moveValue: Double
    public let moveGoal: Double
    public let exerciseMinutes: Double
    public let exerciseGoal: Double
    public let standHours: Double
    public let standGoal: Double

    public var id: Date { date }

    public var moveProgress: Double {
        guard moveGoal > 0 else { return 0 }
        return moveValue / moveGoal
    }

    public var exerciseProgress: Double {
        guard exerciseGoal > 0 else { return 0 }
        return exerciseMinutes / exerciseGoal
    }

    public var standProgress: Double {
        guard standGoal > 0 else { return 0 }
        return standHours / standGoal
    }

    public init(
        date: Date,
        moveValue: Double,
        moveGoal: Double,
        exerciseMinutes: Double,
        exerciseGoal: Double,
        standHours: Double,
        standGoal: Double
    ) {
        self.date = date
        self.moveValue = moveValue
        self.moveGoal = moveGoal
        self.exerciseMinutes = exerciseMinutes
        self.exerciseGoal = exerciseGoal
        self.standHours = standHours
        self.standGoal = standGoal
    }
}
