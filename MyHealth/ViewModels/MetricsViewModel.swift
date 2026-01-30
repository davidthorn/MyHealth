//
//  MetricsViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation

@MainActor
public final class MetricsViewModel: ObservableObject {
    @Published public private(set) var title: String
    @Published public var path: [MetricsRoute]

    private let service: MetricsServiceProtocol
    private var task: Task<Void, Never>?

    public init(service: MetricsServiceProtocol) {
        self.service = service
        self.title = "Metrics"
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
