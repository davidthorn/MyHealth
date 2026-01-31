//
//  WorkoutListItemViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class WorkoutListItemViewModel: ObservableObject {
    @Published public private(set) var title: String
    @Published public private(set) var typeName: String
    @Published public private(set) var timeRange: String

    private let service: WorkoutListItemServiceProtocol
    private let workout: Workout
    private var task: Task<Void, Never>?

    public init(service: WorkoutListItemServiceProtocol, workout: Workout) {
        self.service = service
        self.workout = workout
        self.title = workout.title
        self.typeName = workout.type.displayName
        self.timeRange = ""
    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let service = self?.service, let workout = self?.workout else { return }
            for await update in service.updates(for: workout) {
                guard let self, !Task.isCancelled else { break }
                self.title = update.title
                self.typeName = update.typeName
                self.timeRange = update.timeRange
            }
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
    }
}
