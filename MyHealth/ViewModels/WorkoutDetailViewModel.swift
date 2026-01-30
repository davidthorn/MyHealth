//
//  WorkoutDetailViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation

@MainActor
public final class WorkoutDetailViewModel: ObservableObject {
    @Published public private(set) var workout: Workout?
    @Published public var isDeleteAlertPresented: Bool
    @Published public var errorMessage: String?

    private let service: WorkoutDetailServiceProtocol
    private let id: UUID
    private var task: Task<Void, Never>?

    public init(service: WorkoutDetailServiceProtocol, id: UUID) {
        self.service = service
        self.id = id
        self.workout = nil
        self.isDeleteAlertPresented = false
        self.errorMessage = nil
    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let self else { return }
            let service = self.service
            for await update in service.updates(for: id) {
                guard !Task.isCancelled else { break }
                self.workout = update.workout
            }
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
    }

    public func requestDelete() {
        isDeleteAlertPresented = true
    }

    public func delete() async -> Bool {
        do {
            try await service.delete(id: id)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
