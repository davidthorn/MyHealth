//
//  HealthKitAdapterProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthKitAdapterProtocol {
    func requestAuthorization() async -> Bool
    func requestHeartRateAuthorization() async -> Bool
    func workoutsStream() -> AsyncStream<[Workout]>
    func workout(id: UUID) async throws -> Workout?
    func deleteWorkout(id: UUID) async throws
    func heartRateSummaryStream() -> AsyncStream<HeartRateSummary>
}
