//
//  WorkoutDetailServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol WorkoutDetailServiceProtocol {
    func updates(for id: UUID) -> AsyncStream<Workout?>
    func routeUpdates(for id: UUID) -> AsyncStream<[WorkoutRoutePoint]>
    func heartRateUpdates(start: Date, end: Date) -> AsyncStream<[HeartRateReading]>
    func delete(id: UUID) async throws
}
