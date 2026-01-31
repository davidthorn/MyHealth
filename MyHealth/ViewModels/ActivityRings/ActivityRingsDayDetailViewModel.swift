//
//  ActivityRingsDayDetailViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class ActivityRingsDayDetailViewModel: ObservableObject {
    @Published public private(set) var day: ActivityRingsDay?
    @Published public private(set) var isAuthorized: Bool

    private let service: ActivityRingsDayDetailServiceProtocol
    private let date: Date
    private var task: Task<Void, Never>?

    public init(service: ActivityRingsDayDetailServiceProtocol, date: Date) {
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

    private func startUpdates(with service: ActivityRingsDayDetailServiceProtocol) {
        guard task == nil else { return }
        let mDate = date
        task = Task { [weak self] in
            for await update in service.updates(for: mDate) {
                guard let self, !Task.isCancelled else { break }
                self.day = update.day
            }
        }
    }
}
