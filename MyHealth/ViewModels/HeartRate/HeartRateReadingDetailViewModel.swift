//
//  HeartRateReadingDetailViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class HeartRateReadingDetailViewModel: ObservableObject {
    @Published public private(set) var reading: HeartRateReading?
    @Published public private(set) var isAuthorized: Bool
    @Published public private(set) var errorMessage: String?

    private let service: HeartRateReadingDetailServiceProtocol
    private let readingId: UUID
    private var task: Task<Void, Never>?

    public init(service: HeartRateReadingDetailServiceProtocol, id: UUID) {
        self.service = service
        self.readingId = id
        self.reading = nil
        self.isAuthorized = true
        self.errorMessage = nil
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

    private func startUpdates(with service: HeartRateReadingDetailServiceProtocol) {
        guard task == nil else { return }
        let _readingId = readingId
        task = Task { [weak self] in
            for await update in service.updates(for: _readingId) {
                guard !Task.isCancelled else { break }
                guard let self else { return }
                self.reading = update.reading
            }
        }
    }
}
