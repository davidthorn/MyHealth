//
//  HealthKitExerciseMinutesAdapter.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public final class HealthKitExerciseMinutesAdapter: HealthKitExerciseMinutesAdapterProtocol {
    private let storeAdaptor: HealthStoreAdaptorProtocol

    public init(storeAdaptor: HealthStoreAdaptorProtocol) {
        self.storeAdaptor = storeAdaptor
    }

    public static func live() -> HealthKitExerciseMinutesAdapter {
        HealthKitExerciseMinutesAdapter(storeAdaptor: HealthStoreAdaptor())
    }

    public func requestAuthorization() async -> Bool {
        await storeAdaptor.authorizationProvider.requestExerciseMinutesAuthorization()
    }

    public func exerciseMinutesSummaryStream(days: Int) -> AsyncStream<ExerciseMinutesSummary> {
        AsyncStream { continuation in
            let task = Task { [storeAdaptor] in
                let values = await storeAdaptor.fetchExerciseMinutes(days: days)
                guard !Task.isCancelled else { return }
                let sorted = values.sorted { $0.date > $1.date }
                let latest = sorted.first
                let previous = Array(sorted.dropFirst())
                continuation.yield(ExerciseMinutesSummary(latest: latest, previous: previous))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
