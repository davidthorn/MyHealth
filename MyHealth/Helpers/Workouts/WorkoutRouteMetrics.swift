//
//  WorkoutRouteMetrics.swift
//  MyHealth
//
//  Created by Codex.
//

import CoreLocation
import Foundation
import Models

public struct WorkoutRouteMetrics {
    public init() {}

    public static func totalDistance(points: [WorkoutRoutePoint]) -> Double? {
        guard points.count >= 2 else { return nil }
        let sorted = points.sorted { $0.timestamp < $1.timestamp }
        var distance: Double = 0
        var previous = sorted[0]
        for point in sorted.dropFirst() {
            let startLocation = CLLocation(latitude: previous.latitude, longitude: previous.longitude)
            let endLocation = CLLocation(latitude: point.latitude, longitude: point.longitude)
            let segment = endLocation.distance(from: startLocation)
            if segment > 0 {
                distance += segment
            }
            previous = point
        }
        return distance > 0 ? distance : nil
    }

    public static func averageHeartRate(readings: [HeartRateReading]) -> Double? {
        guard !readings.isEmpty else { return nil }
        let total = readings.map(\.bpm).reduce(0, +)
        return total / Double(readings.count)
    }
}
