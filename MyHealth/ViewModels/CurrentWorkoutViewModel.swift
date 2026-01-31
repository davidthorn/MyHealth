//
//  CurrentWorkoutViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class CurrentWorkoutViewModel: ObservableObject {
    @Published public private(set) var currentSession: WorkoutSession?
    @Published public private(set) var errorMessage: String?
    @Published public private(set) var elapsedText: String?

    private let service: WorkoutFlowServiceProtocol
    private var task: Task<Void, Never>?
    private var timerCancellable: AnyCancellable?

    public init(service: WorkoutFlowServiceProtocol) {
        self.service = service
        self.currentSession = nil
        self.errorMessage = nil
        self.elapsedText = nil
    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let service = self?.service else { return }
            for await update in service.updates() {
                guard let self, !Task.isCancelled else { break }
                self.currentSession = update.currentSession
                self.configureTimer(for: update.currentSession)
            }
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
        stopTimer()
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

    private func configureTimer(for session: WorkoutSession?) {
        guard let session else {
            stopTimer()
            elapsedText = nil
            return
        }

        updateElapsedText(startedAt: session.startedAt)
        if timerCancellable == nil {
            timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in
                    guard let self, !Task.isCancelled else { return }
                    self.updateElapsedText(startedAt: session.startedAt)
                }
        }
    }

    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    private func updateElapsedText(startedAt: Date) {
        elapsedText = startedAt.elapsedText()
    }
}
