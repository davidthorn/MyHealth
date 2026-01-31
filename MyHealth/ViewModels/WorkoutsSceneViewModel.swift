//
//  WorkoutsSceneViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class WorkoutsSceneViewModel: ObservableObject {
    @Published public var path: [WorkoutsRoute]
    @Published public private(set) var currentSession: WorkoutSession?

    private let service: WorkoutFlowServiceProtocol
    private var task: Task<Void, Never>?

    public init(service: WorkoutFlowServiceProtocol) {
        self.service = service
        self.path = []
        self.currentSession = nil
    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let service = self?.service else { return }
            for await update in service.updates() {
                guard let self, !Task.isCancelled else { break }
                self.currentSession = update.currentSession
                if update.currentSession != nil {
                    self.path = []
                }
            }
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
    }
}
