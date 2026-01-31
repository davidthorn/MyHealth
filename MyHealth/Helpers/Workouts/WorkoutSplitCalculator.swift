//
//  WorkoutSplitCalculator.swift
//  MyHealth
//
//  Created by Codex.
//

import CoreLocation
import Foundation
import Models

public struct WorkoutSplitCalculator {
    public init() {}

    public nonisolated static func splits(from points: [WorkoutRoutePoint]) -> [WorkoutSplit] {
        let sortedPoints = points.sorted { $0.timestamp < $1.timestamp }
        guard sortedPoints.count >= 2 else { return [] }

        let startDate = sortedPoints[0].timestamp
        var splits: [WorkoutSplit] = []
        var lastSplitElapsed: TimeInterval = 0
        var cumulativeDistance: Double = 0
        var cumulativeTime: TimeInterval = 0
        var nextSplitDistance: Double = 1000
        var splitIndex = 1

        var previous = sortedPoints[0]
        for point in sortedPoints.dropFirst() {
            let startLocation = CLLocation(latitude: previous.latitude, longitude: previous.longitude)
            let endLocation = CLLocation(latitude: point.latitude, longitude: point.longitude)
            var segmentDistance = endLocation.distance(from: startLocation)
            var segmentTime = point.timestamp.timeIntervalSince(previous.timestamp)

            if segmentDistance <= 0 || segmentTime <= 0 {
                previous = point
                continue
            }

            while cumulativeDistance + segmentDistance >= nextSplitDistance {
                let remaining = nextSplitDistance - cumulativeDistance
                let ratio = remaining / segmentDistance
                let timeAtSplitElapsed = cumulativeTime + segmentTime * ratio
                let splitDuration = timeAtSplitElapsed - lastSplitElapsed
                let splitStart = startDate.addingTimeInterval(lastSplitElapsed)
                let splitEnd = startDate.addingTimeInterval(timeAtSplitElapsed)

                splits.append(
                    WorkoutSplit(
                        index: splitIndex,
                        distanceMeters: 1000,
                        durationSeconds: splitDuration,
                        paceSecondsPerKilometer: splitDuration,
                        startDate: splitStart,
                        endDate: splitEnd
                    )
                )

                splitIndex += 1
                lastSplitElapsed = timeAtSplitElapsed

                segmentDistance -= remaining
                segmentTime -= segmentTime * ratio
                cumulativeDistance = nextSplitDistance
                cumulativeTime = timeAtSplitElapsed
                nextSplitDistance += 1000

                if segmentDistance <= 0 || segmentTime <= 0 { break }
            }

            cumulativeDistance += segmentDistance
            cumulativeTime += segmentTime
            previous = point
        }

        let completedDistance = Double(splitIndex - 1) * 1000
        let remainingDistance = max(cumulativeDistance - completedDistance, 0)
        if remainingDistance > 0, let lastPoint = sortedPoints.last {
            let splitStart = startDate.addingTimeInterval(lastSplitElapsed)
            let splitEnd = lastPoint.timestamp
            let splitDuration = splitEnd.timeIntervalSince(splitStart)
            let pace = splitDuration / (remainingDistance / 1000)
            splits.append(
                WorkoutSplit(
                    index: splitIndex,
                    distanceMeters: remainingDistance,
                    durationSeconds: splitDuration,
                    paceSecondsPerKilometer: pace,
                    startDate: splitStart,
                    endDate: splitEnd
                )
            )
        }

        return splits
    }

    public nonisolated static func applyAverageHeartRates(
        _ readings: [HeartRateReading],
        to splits: [WorkoutSplit]
    ) -> [WorkoutSplit] {
        var averageMap: [UUID: Double] = [:]
        for split in splits {
            let samples = readings.filter { sample in
                sample.endDate >= split.startDate && sample.startDate <= split.endDate
            }
            guard !samples.isEmpty else { continue }
            let average = samples.map(\.bpm).reduce(0, +) / Double(samples.count)
            averageMap[split.id] = average
        }
        return splits.map { split in
            WorkoutSplit(
                id: split.id,
                index: split.index,
                distanceMeters: split.distanceMeters,
                durationSeconds: split.durationSeconds,
                paceSecondsPerKilometer: split.paceSecondsPerKilometer,
                startDate: split.startDate,
                endDate: split.endDate,
                averageHeartRateBpm: averageMap[split.id]
            )
        }
    }

    public nonisolated static func heartRateLinePoints(from readings: [HeartRateReading]) -> [HeartRateRangePoint] {
        guard !readings.isEmpty else { return [] }
        let sorted = readings.sorted { $0.date < $1.date }
        return sorted.map { reading in
            HeartRateRangePoint(date: reading.date, bpm: reading.bpm)
        }
    }
}
