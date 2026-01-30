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

    public init() {
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

    public func endWorkout() {
        currentSession = nil
        subject.send(currentUpdate())
    }

    private func currentUpdate() -> WorkoutFlowUpdate {
        WorkoutFlowUpdate(availableTypes: WorkoutType.allCases, currentSession: currentSession)
    }
}
