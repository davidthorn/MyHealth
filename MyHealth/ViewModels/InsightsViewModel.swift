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
    @Published public var path: [InsightsRoute]

    private let service: InsightsServiceProtocol
    private var task: Task<Void, Never>?

    public init(service: InsightsServiceProtocol) {
        self.service = service
        self.title = "Insights"
        self.path = []

    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let service = self?.service else { return }
            for await update in service.updates() {
                guard let self, !Task.isCancelled else { break }
                self.title = update.title
            }
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
    }
}
