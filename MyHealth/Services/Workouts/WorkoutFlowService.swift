//
//  WorkoutFlowService.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class WorkoutFlowService: WorkoutFlowServiceProtocol {
    private var currentSession: WorkoutSession?
    private let subject: CurrentValueSubject<WorkoutFlowUpdate, Never>
    private let store: WorkoutStoreProtocol

    public init(store: WorkoutStoreProtocol) {
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
        currentSession = WorkoutSession(type: type)
        subject.send(currentUpdate())
    }

    public func beginWorkout() {
        guard let session = currentSession, session.status == .notStarted else { return }
        currentSession = WorkoutSession(
            type: session.type,
            startedAt: Date(),
            status: .active,
            pausedAt: nil,
            totalPausedSeconds: 0
        )
        subject.send(currentUpdate())
    }

    public func pauseWorkout() {
        guard let session = currentSession, session.status == .active else { return }
        currentSession = WorkoutSession(
            type: session.type,
            startedAt: session.startedAt,
            status: .paused,
            pausedAt: Date(),
            totalPausedSeconds: session.totalPausedSeconds
        )
        subject.send(currentUpdate())
    }

    public func resumeWorkout() {
        guard let session = currentSession, session.status == .paused, let pausedAt = session.pausedAt else { return }
        let newPaused = session.totalPausedSeconds + Date().timeIntervalSince(pausedAt)
        currentSession = WorkoutSession(
            type: session.type,
            startedAt: session.startedAt,
            status: .active,
            pausedAt: nil,
            totalPausedSeconds: newPaused
        )
        subject.send(currentUpdate())
    }

    public func endWorkout() async throws {
        guard let session = currentSession else {
            subject.send(currentUpdate())
            return
        }
        guard let startedAt = session.startedAt, session.status != .notStarted else {
            currentSession = nil
            subject.send(currentUpdate())
            return
        }
        currentSession = nil
        subject.send(currentUpdate())
        let workout = Workout(
            id: UUID(),
            title: session.type.displayName,
            type: session.type,
            startedAt: startedAt,
            endedAt: Date()
        )
        try await store.create(workout)
    }

    private func currentUpdate() -> WorkoutFlowUpdate {
        WorkoutFlowUpdate(availableTypes: WorkoutType.allCases, currentSession: currentSession)
    }
}
