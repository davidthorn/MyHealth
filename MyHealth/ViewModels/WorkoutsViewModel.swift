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
    @Published public private(set) var isAuthorized: Bool

    private let service: WorkoutsServiceProtocol
    private var task: Task<Void, Never>?

    public init(service: WorkoutsServiceProtocol) {
        self.service = service
        self.title = "Workouts"
        self.workouts = []
        self.availableTypes = []
        self.selectedType = nil
        self.isAuthorized = true
    }

    public func start() {
        guard task == nil else { return }
        Task { [weak self] in
            guard let service = self?.service, !Task.isCancelled else { return }
            let isAuthorized = await service.requestAuthorization()
            guard !Task.isCancelled else { return }
            self?.isAuthorized = isAuthorized
            guard isAuthorized else { return }
            self?.startUpdates(with: service)
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
    }

    public func requestAuthorization() {
        Task { [weak self] in
            guard let service = self?.service, !Task.isCancelled else { return }
            let isAuthorized = await service.requestAuthorization()
            guard !Task.isCancelled else { return }
            self?.isAuthorized = isAuthorized
            if isAuthorized {
                self?.startUpdates(with: service)
            }
        }
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

    private func startUpdates(with service: WorkoutsServiceProtocol) {
        guard task == nil else { return }
        task = Task { [weak self] in
            for await update in service.updates() {
                guard let self, !Task.isCancelled else { break }
                self.title = update.title
                let sortedWorkouts = update.workouts.sorted { $0.startedAt > $1.startedAt }
                self.workouts = sortedWorkouts
                self.availableTypes = Self.types(from: sortedWorkouts)
            }
        }
    }
}
