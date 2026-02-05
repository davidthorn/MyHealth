//
//  TodayViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class TodayViewModel: ObservableObject {
    @Published public private(set) var title: String
    @Published public var path: [TodayRoute]
    @Published public private(set) var latestWorkout: TodayLatestWorkout?
    @Published public private(set) var activityRingsDay: ActivityRingsDay?

    private let service: TodayServiceProtocol
    private var task: Task<Void, Never>?

    public init(service: TodayServiceProtocol) {
        self.service = service
        self.title = "Today"
        self.path = []
        self.latestWorkout = nil
        self.activityRingsDay = nil

    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let service = self?.service else { return }
            for await update in service.updates() {
                guard let self, !Task.isCancelled else { break }
                self.title = update.title
                self.latestWorkout = update.latestWorkout
                self.activityRingsDay = update.activityRingsDay
            }
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
    }
}
