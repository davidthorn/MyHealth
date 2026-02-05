//
//  SleepEntriesViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models
import Combine

@MainActor
public final class SleepEntriesViewModel: ObservableObject {
    @Published public private(set) var entries: [SleepEntry]
    @Published public private(set) var isAuthorized: Bool

    private let service: SleepEntryServiceProtocol
    private var task: Task<Void, Never>?
    private let days: Int

    public init(service: SleepEntryServiceProtocol, days: Int = 14) {
        self.service = service
        self.entries = []
        self.isAuthorized = true
        self.days = days
    }

    public func start() {
        guard task == nil else { return }
        Task { [weak self] in
            guard let self, !Task.isCancelled else { return }
            let isAuthorized = await service.requestReadAuthorization()
            guard !Task.isCancelled else { return }
            self.isAuthorized = isAuthorized
            guard isAuthorized else { return }
            self.startUpdates()
        }
    }

    public func refresh() {
        stop()
        start()
    }

    public func stop() {
        task?.cancel()
        task = nil
    }

    private func startUpdates() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let self else { return }
            for await entries in service.entries(days: days) {
                guard !Task.isCancelled else { break }
                self.entries = entries
            }
        }
    }
}
