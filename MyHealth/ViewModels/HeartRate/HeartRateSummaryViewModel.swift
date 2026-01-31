//
//  HeartRateSummaryViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class HeartRateSummaryViewModel: ObservableObject {
    @Published public private(set) var summary: HeartRateSummary?
    @Published public private(set) var isAuthorized: Bool

    private let service: HeartRateSummaryServiceProtocol
    private var task: Task<Void, Never>?

    public init(service: HeartRateSummaryServiceProtocol) {
        self.service = service
        self.summary = nil
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

    private func startUpdates(with service: HeartRateSummaryServiceProtocol) {
        guard task == nil else { return }
        task = Task { [weak self] in
            for await update in service.updates() {
                guard let self, !Task.isCancelled else { break }
                self.summary = update.summary
            }
        }
    }
}
