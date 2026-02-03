//
//  HealthKitExerciseMinutesAdapterProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthKitExerciseMinutesAdapterProtocol: Sendable {
    func requestAuthorization() async -> Bool
    func exerciseMinutesSummaryStream(days: Int) -> AsyncStream<ExerciseMinutesSummary>
}
