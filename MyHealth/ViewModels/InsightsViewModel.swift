//
//  InsightsViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation

@MainActor
public final class InsightsViewModel: ObservableObject {
    @Published public private(set) var title: String
    @Published public private(set) var insights: [InsightItem]
    @Published public private(set) var isAuthorized: Bool

    private let service: InsightsServiceProtocol
    private var task: Task<Void, Never>?

    public init(service: InsightsServiceProtocol) {
        self.service = service
        self.title = "Insights"
        self.insights = []
        self.isAuthorized = false
    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let service = self?.service else { return }
            for await update in service.updates() {
                guard let self, !Task.isCancelled else { break }
                self.title = update.title
                self.isAuthorized = update.isAuthorized
                self.insights = update.insights
            }
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
    }

    public func requestAuthorization() {
        task?.cancel()
        task = Task { [weak self] in
            guard let service = self?.service else { return }
            let isAuthorized = await service.requestAuthorization()
            guard let self, !Task.isCancelled else { return }
            self.isAuthorized = isAuthorized
            if isAuthorized {
                self.stop()
                self.start()
            }
        }
    }
}
