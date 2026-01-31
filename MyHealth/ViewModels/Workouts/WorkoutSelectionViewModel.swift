//
//  WorkoutSelectionViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class WorkoutSelectionViewModel: ObservableObject {
    @Published public private(set) var types: [WorkoutType]

    private let service: WorkoutFlowServiceProtocol
    private var task: Task<Void, Never>?

    public init(service: WorkoutFlowServiceProtocol) {
        self.service = service
        self.types = []
    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let service = self?.service else { return }
            for await update in service.updates() {
                guard let self, !Task.isCancelled else { break }
                self.types = update.availableTypes
            }
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
    }

    public func startWorkout(type: WorkoutType) {
        service.startWorkout(type: type)
    }
}
