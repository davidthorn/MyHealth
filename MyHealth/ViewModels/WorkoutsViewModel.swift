//
//  WorkoutsViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation

@MainActor
public final class WorkoutsViewModel: ObservableObject {
    @Published public private(set) var title: String
    @Published public private(set) var workouts: [Workout]

    private let service: WorkoutsServiceProtocol
    private var task: Task<Void, Never>?

    public init(service: WorkoutsServiceProtocol) {
        self.service = service
        self.title = "Workouts"
        self.workouts = []
    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let service = self?.service else { return }
            for await update in service.updates() {
                guard let self, !Task.isCancelled else { break }
                self.title = update.title
                self.workouts = update.workouts.sorted { $0.startedAt > $1.startedAt }
            }
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
    }
}
