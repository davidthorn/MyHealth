//
//  WorkoutListItemService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

@MainActor
public final class WorkoutListItemService: WorkoutListItemServiceProtocol {
    private let workoutSource: WorkoutDataSourceProtocol
    private let heartRateSource: HeartRateDataSourceProtocol

    public init(workoutSource: WorkoutDataSourceProtocol, heartRateSource: HeartRateDataSourceProtocol) {
        self.workoutSource = workoutSource
        self.heartRateSource = heartRateSource
    }

    public func updates(for workout: Workout) -> AsyncStream<WorkoutListItemUpdate> {
        AsyncStream { continuation in
            let task = Task { [workoutSource, heartRateSource] in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM yyyy"
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                let dateText = dateFormatter.string(from: workout.startedAt)
                let startTime = timeFormatter.string(from: workout.startedAt)
                let endTime = timeFormatter.string(from: workout.endedAt)
                let timeRange = "Date: \(dateText)\nStart: \(startTime)\nEnd: \(endTime)"
                let durationSeconds = workout.endedAt.timeIntervalSince(workout.startedAt)

                let routePoints = (try? await workoutSource.workoutRoute(id: workout.id)) ?? []
                let distanceMeters = WorkoutRouteMetrics.totalDistance(points: routePoints)

                let isAuthorized = await heartRateSource.requestAuthorization()
                let averageHeartRateBpm: Double?
                if isAuthorized {
                    let readings = await heartRateSource.heartRateReadings(from: workout.startedAt, to: workout.endedAt)
                    averageHeartRateBpm = WorkoutRouteMetrics.averageHeartRate(readings: readings)
                } else {
                    averageHeartRateBpm = nil
                }

                guard !Task.isCancelled else { return }
                continuation.yield(
                    WorkoutListItemUpdate(
                        title: workout.title,
                        typeName: workout.type.displayName,
                        timeRange: timeRange,
                        durationSeconds: durationSeconds,
                        routePoints: routePoints,
                        distanceMeters: distanceMeters,
                        averageHeartRateBpm: averageHeartRateBpm
                    )
                )
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
