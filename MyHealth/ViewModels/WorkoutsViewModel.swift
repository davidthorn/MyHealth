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
    @Published public private(set) var availableTypes: [WorkoutType]
    @Published public var selectedType: WorkoutType?

    private let service: WorkoutsServiceProtocol
    private var task: Task<Void, Never>?

    public init(service: WorkoutsServiceProtocol) {
        self.service = service
        self.title = "Workouts"
        self.workouts = []
        self.availableTypes = []
        self.selectedType = nil
    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let service = self?.service else { return }
            for await update in service.updates() {
                guard let self, !Task.isCancelled else { break }
                self.title = update.title
                let sortedWorkouts = update.workouts.sorted { $0.startedAt > $1.startedAt }
                self.workouts = sortedWorkouts
                self.availableTypes = Self.types(from: sortedWorkouts)
            }
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
    }

    public var filteredWorkouts: [Workout] {
        guard let selectedType else { return workouts }
        return workouts.filter { $0.type == selectedType }
    }

    public func select(type: WorkoutType?) {
        selectedType = type
    }

    private static func types(from workouts: [Workout]) -> [WorkoutType] {
        let unique = Set(workouts.map(\.type))
        return unique.sorted { $0.displayName < $1.displayName }
    }
}
