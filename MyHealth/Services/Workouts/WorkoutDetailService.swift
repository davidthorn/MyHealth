//
//  WorkoutDetailService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public enum WorkoutDeleteError: Error, LocalizedError {
    case authorizationDenied

    public var errorDescription: String? {
        switch self {
        case .authorizationDenied:
            return "Health access is required to delete a workout. Enable Health permissions in Settings."
        }
    }
}

public final class WorkoutDetailService: WorkoutDetailServiceProtocol {
    private let source: WorkoutDataSourceProtocol
    private let heartRateSource: HeartRateDataSourceProtocol

    public init(source: WorkoutDataSourceProtocol, heartRateSource: HeartRateDataSourceProtocol) {
        self.source = source
        self.heartRateSource = heartRateSource
    }

    public func updates(for id: UUID) -> AsyncStream<Workout?> {
        AsyncStream { continuation in
            let task = Task { [source] in
                let stream = source.workoutsStream()
                for await items in stream {
                    if Task.isCancelled { break }
                    let workout = items.first { $0.id == id }
                    continuation.yield(workout)
                }
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    public func routeUpdates(for id: UUID) -> AsyncStream<[WorkoutRoutePoint]> {
        AsyncStream { continuation in
            let task = Task { [source] in
                do {
                    let points = try await source.workoutRoute(id: id)
                    guard !Task.isCancelled else { return }
                    continuation.yield(points)
                } catch {
                    if Task.isCancelled { return }
                    continuation.yield([])
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    public func heartRateUpdates(start: Date, end: Date) -> AsyncStream<[HeartRateReading]> {
        AsyncStream { continuation in
            let task = Task { [heartRateSource] in
                let isAuthorized = await heartRateSource.requestAuthorization()
                guard isAuthorized, !Task.isCancelled else {
                    continuation.finish()
                    return
                }
                let readings = await heartRateSource.heartRateReadings(from: start, to: end)
                guard !Task.isCancelled else { return }
                continuation.yield(readings)
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    public func delete(id: UUID) async throws {
        let source = source
        let isAuthorized = await source.requestDeleteAuthorization()
        guard isAuthorized else {
            throw WorkoutDeleteError.authorizationDenied
        }
        try await Task.detached {
            try await source.deleteWorkout(id: id)
        }.value
    }
}
