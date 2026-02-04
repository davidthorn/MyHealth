//
//  HealthStoreWorkoutReading.swift
//  MyHealth
//
//  Created by Codex.
//

import CoreLocation
import Foundation
import HealthKit
import Models

public protocol HealthStoreWorkoutReading {
    var healthStore: HKHealthStore { get }
}

public extension HealthStoreWorkoutReading where Self: HealthStoreSampleQuerying {
    func fetchWorkouts() async -> [Workout] {
        let sampleType = HKObjectType.workoutType()
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let samples: [HKWorkout] = await fetchSamples(
            sampleType: sampleType,
            predicate: nil,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        )
        return samples.compactMap(Workout.init(healthKitWorkout:))
    }

    func fetchWorkout(id: UUID) async throws -> Workout {
        let workout = try await fetchHealthKitWorkout(id: id)
        guard let model = Workout(healthKitWorkout: workout) else {
            throw HealthKitAdapterError.unmappedWorkoutType
        }
        return model
    }

    func fetchWorkoutRoute(id: UUID) async throws -> [WorkoutRoutePoint] {
        let workout = try await fetchHealthKitWorkout(id: id)
        let routeType = HKSeriesType.workoutRoute()
        let predicate = HKQuery.predicateForObjects(from: workout)
        let routes: [HKWorkoutRoute] = await fetchSamples(
            sampleType: routeType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: nil
        )

        var points: [WorkoutRoutePoint] = []
        for route in routes {
            let locations = try await fetchLocations(for: route)
            points.append(contentsOf: locations.map {
                WorkoutRoutePoint(
                    latitude: $0.coordinate.latitude,
                    longitude: $0.coordinate.longitude,
                    timestamp: $0.timestamp,
                    horizontalAccuracy: $0.horizontalAccuracy
                )
            })
        }
        return points.sorted { $0.timestamp < $1.timestamp }
    }

    func deleteWorkout(id: UUID) async throws {
        let workout = try await fetchHealthKitWorkout(id: id)
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            healthStore.delete([workout]) { success, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                if success {
                    continuation.resume(returning: ())
                } else {
                    continuation.resume(throwing: HealthKitAdapterError.deleteFailed)
                }
            }
        }
    }

    private func fetchLocations(for route: HKWorkoutRoute) async throws -> [CLLocation] {
        return try await withCheckedThrowingContinuation { continuation in
            var collected: [CLLocation] = []
            var didResume = false
            let query = HKWorkoutRouteQuery(route: route) { _, locations, done, error in
                if let error, !didResume {
                    didResume = true
                    continuation.resume(throwing: error)
                    return
                }
                if let locations {
                    collected.append(contentsOf: locations)
                }
                if done, !didResume {
                    didResume = true
                    continuation.resume(returning: collected)
                }
            }
            healthStore.execute(query)
        }
    }

    private func fetchHealthKitWorkout(id: UUID) async throws -> HKWorkout {
        let sampleType = HKObjectType.workoutType()
        let predicate = HKQuery.predicateForObject(with: id)
        return try await fetchSample(
            sampleType: sampleType,
            predicate: predicate,
            errorOnMissing: HealthKitAdapterError.workoutNotFound
        )
    }
}
