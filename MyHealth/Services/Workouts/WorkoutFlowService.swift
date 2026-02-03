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
            WorkoutFlowUpdate(availableTypes: WorkoutType.outdoorSupported, currentSession: nil)
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

    public func beginWorkout() async throws {
        guard let session = currentSession, session.status == .notStarted else { return }
        try await store.beginWorkout(type: session.type)
        currentSession = WorkoutSession(
            type: session.type,
            startedAt: Date(),
            status: .active,
            pausedAt: nil,
            totalPausedSeconds: 0
        )
        subject.send(currentUpdate())
    }

    public func pauseWorkout() async throws {
        guard let session = currentSession, session.status == .active else { return }
        try await store.pauseWorkout()
        currentSession = WorkoutSession(
            type: session.type,
            startedAt: session.startedAt,
            status: .paused,
            pausedAt: Date(),
            totalPausedSeconds: session.totalPausedSeconds
        )
        subject.send(currentUpdate())
    }

    public func resumeWorkout() async throws {
        guard let session = currentSession, session.status == .paused, let pausedAt = session.pausedAt else { return }
        try await store.resumeWorkout()
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
        guard let _ = session.startedAt, session.status != .notStarted else {
            currentSession = nil
            subject.send(currentUpdate())
            return
        }
        currentSession = nil
        subject.send(currentUpdate())
        try await store.endWorkout()
    }

    private func currentUpdate() -> WorkoutFlowUpdate {
        WorkoutFlowUpdate(availableTypes: WorkoutType.outdoorSupported, currentSession: currentSession)
    }
}
