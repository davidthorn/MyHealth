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

@MainActor
internal protocol HealthStoreWorkoutReading {
    var healthStore: HKHealthStore { get }
}

@MainActor
extension HealthStoreWorkoutReading {
    public func fetchWorkouts() async -> [Workout] {
        return await withCheckedContinuation { continuation in
            let sampleType = HKObjectType.workoutType()
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(
                sampleType: sampleType,
                predicate: nil,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                let workouts = (samples as? [HKWorkout])?.compactMap(Workout.init(healthKitWorkout:)) ?? []
                continuation.resume(returning: workouts)
            }
            healthStore.execute(query)
        }
    }

    public func fetchWorkout(id: UUID) async throws -> Workout {
        let workout = try await fetchHealthKitWorkout(id: id)
        guard let model = Workout(healthKitWorkout: workout) else {
            throw HealthKitAdapterError.unmappedWorkoutType
        }
        return model
    }

    public func fetchWorkoutRoute(id: UUID) async throws -> [WorkoutRoutePoint] {
        let workout = try await fetchHealthKitWorkout(id: id)
        let routeType = HKSeriesType.workoutRoute()
        let predicate = HKQuery.predicateForObjects(from: workout)
        let routes = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKWorkoutRoute], Error>) in
            let query = HKSampleQuery(
                sampleType: routeType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: nil
            ) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                let routes = (samples as? [HKWorkoutRoute]) ?? []
                continuation.resume(returning: routes)
            }
            healthStore.execute(query)
        }

        var points: [WorkoutRoutePoint] = []
        for route in routes {
            let locations = try await fetchLocations(for: route)
            points.append(contentsOf: locations.map {
                WorkoutRoutePoint(
                    latitude: $0.coordinate.latitude,
                    longitude: $0.coordinate.longitude,
                    timestamp: $0.timestamp
                )
            })
        }
        return points.sorted { $0.timestamp < $1.timestamp }
    }

    public func deleteWorkout(id: UUID) async throws {
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
        return try await withCheckedThrowingContinuation { continuation in
            let sampleType = HKObjectType.workoutType()
            let predicate = HKQuery.predicateForObject(with: id)
            let query = HKSampleQuery(
                sampleType: sampleType,
                predicate: predicate,
                limit: 1,
                sortDescriptors: nil
            ) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let workout = (samples as? [HKWorkout])?.first else {
                    continuation.resume(throwing: HealthKitAdapterError.workoutNotFound)
                    return
                }
                continuation.resume(returning: workout)
            }
            healthStore.execute(query)
        }
    }
}
