//
//  CurrentWorkoutViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation

@MainActor
public final class CurrentWorkoutViewModel: ObservableObject {
    @Published public private(set) var currentSession: WorkoutSession?
    @Published public private(set) var errorMessage: String?

    private let service: WorkoutFlowServiceProtocol
    private var task: Task<Void, Never>?

    public init(service: WorkoutFlowServiceProtocol) {
        self.service = service
        self.currentSession = nil
        self.errorMessage = nil
    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let service = self?.service else { return }
            for await update in service.updates() {
                guard let self, !Task.isCancelled else { break }
                self.currentSession = update.currentSession
            }
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
    }

    public func endWorkout() async {
        do {
            try await service.endWorkout()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    public func clearError() {
        errorMessage = nil
    }
}
