//
//  MockLocationService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

@MainActor
public final class MockLocationService: LocationServiceProtocol {
    public init() {}

    public func locationUpdates() -> AsyncStream<WorkoutRoutePoint> {
        AsyncStream { continuation in
            let points = Self.mockPoints()
            let task = Task {
                for point in points {
                    if Task.isCancelled { break }
                    continuation.yield(point)
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    private static func mockPoints() -> [WorkoutRoutePoint] {
        let start = Date()
        let coordinates: [(Double, Double)] = [
            (37.3320, -122.0312),
            (37.3326, -122.0306),
            (37.3334, -122.0300),
            (37.3341, -122.0294),
            (37.3349, -122.0288),
            (37.3356, -122.0281),
            (37.3364, -122.0275),
            (37.3371, -122.0269),
            (37.3378, -122.0262),
            (37.3385, -122.0256),
            (37.3392, -122.0250)
        ]
        return coordinates.enumerated().map { index, coordinate in
            WorkoutRoutePoint(
                latitude: coordinate.0,
                longitude: coordinate.1,
                timestamp: start.addingTimeInterval(TimeInterval(index) * 20)
            )
        }
    }
}
