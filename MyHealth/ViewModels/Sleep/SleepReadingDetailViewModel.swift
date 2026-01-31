//
//  SleepReadingDetailViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class SleepReadingDetailViewModel: ObservableObject {
    @Published public private(set) var day: SleepDay?
    @Published public private(set) var isAuthorized: Bool

    private let service: SleepReadingDetailServiceProtocol
    private let date: Date
    private var task: Task<Void, Never>?

    public init(service: SleepReadingDetailServiceProtocol, date: Date) {
        self.service = service
        self.date = date
        self.day = nil
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

    private func startUpdates(with service: SleepReadingDetailServiceProtocol) {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let self else { return }
            let date = self.date
            for await update in service.updates(for: date) {
                guard !Task.isCancelled else { break }
                self.day = update.day
            }
        }
    }
}
