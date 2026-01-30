//
//  WorkoutFlowService.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation

@MainActor
public final class WorkoutFlowService: WorkoutFlowServiceProtocol {
    private var currentSession: WorkoutSession?
    private let subject: CurrentValueSubject<WorkoutFlowUpdate, Never>
    private let store: WorkoutStore

    public init(store: WorkoutStore) {
        self.store = store
        self.currentSession = nil
        self.subject = CurrentValueSubject(
            WorkoutFlowUpdate(availableTypes: WorkoutType.allCases, currentSession: nil)
        )
    }

    public func updates() -> AsyncStream<WorkoutFlowUpdate> {
        AsyncStream { continuation in
            let cancellable = subject.sink { update in
                continuation.yield(update)
            }
            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
    }

    public func startWorkout(type: WorkoutType) {
        currentSession = WorkoutSession(type: type, startedAt: Date())
        subject.send(currentUpdate())
    }

    public func endWorkout() async throws {
        guard let session = currentSession else {
            subject.send(currentUpdate())
            return
        }
        currentSession = nil
        subject.send(currentUpdate())
        let workout = Workout(
            id: UUID(),
            title: session.type.displayName,
            type: session.type,
            startedAt: session.startedAt,
            endedAt: Date()
        )
        try await store.create(workout)
    }

    private func currentUpdate() -> WorkoutFlowUpdate {
        WorkoutFlowUpdate(availableTypes: WorkoutType.allCases, currentSession: currentSession)
    }
}
