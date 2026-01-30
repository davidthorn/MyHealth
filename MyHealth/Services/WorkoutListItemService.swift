//
//  WorkoutListItemService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

@MainActor
public final class WorkoutListItemService: WorkoutListItemServiceProtocol {
    public init() {}

    public func updates(for workout: Workout) -> AsyncStream<WorkoutListItemUpdate> {
        AsyncStream { continuation in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy, HH:mm"
            let start = dateFormatter.string(from: workout.startedAt)
            let end = dateFormatter.string(from: workout.endedAt)
            let timeRange = "\(start) – \(end)"
            continuation.yield(
                WorkoutListItemUpdate(
                    title: workout.title,
                    typeName: workout.type.displayName,
                    timeRange: timeRange
                )
            )
            continuation.finish()
        }
    }
}
