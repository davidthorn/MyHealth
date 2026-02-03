//
//  WorkoutDetailPreviewService.swift
//  MyHealth
//
//  Created by Codex.
//

#if DEBUG
import Foundation
import Models

public final class WorkoutDetailPreviewService: WorkoutDetailServiceProtocol {
    private let workout: Workout
    private let routePoints: [WorkoutRoutePoint]
    private let heartRateReadings: [HeartRateReading]

    public init(workout: Workout, routePoints: [WorkoutRoutePoint], heartRateReadings: [HeartRateReading]) {
        self.workout = workout
        self.routePoints = routePoints
        self.heartRateReadings = heartRateReadings
    }

    public func updates(for id: UUID) -> AsyncStream<Workout?> {
        AsyncStream { continuation in
            if id == workout.id {
                continuation.yield(workout)
            } else {
                continuation.yield(nil)
            }
            continuation.finish()
        }
    }

    public func routeUpdates(for id: UUID) -> AsyncStream<[WorkoutRoutePoint]> {
        AsyncStream { continuation in
            continuation.yield(id == workout.id ? routePoints : [])
            continuation.finish()
        }
    }

    public func heartRateUpdates(start: Date, end: Date) -> AsyncStream<[HeartRateReading]> {
        AsyncStream { continuation in
            continuation.yield(heartRateReadings)
            continuation.finish()
        }
    }

    public func delete(id: UUID) async throws {
        return
    }
}
#endif
