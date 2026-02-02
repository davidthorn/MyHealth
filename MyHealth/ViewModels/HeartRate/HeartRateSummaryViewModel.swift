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

    public var statItems: [(title: String, value: String)] {
        guard let summary else { return [] }
        let average = summary.averageBpm.map { "\(formatNumber($0)) bpm" } ?? "—"
        let min = summary.minBpm.map { "\(formatNumber($0)) bpm" } ?? "—"
        let max = summary.maxBpm.map { "\(formatNumber($0)) bpm" } ?? "—"
        let delta = summary.latestDeltaBpm.map { formatDelta($0) } ?? "—"
        return [
            ("Average", average),
            ("Min", min),
            ("Max", max),
            ("Delta", delta)
        ]
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

    private func formatNumber(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(0)))
    }

    private func formatDelta(_ value: Double) -> String {
        let symbol = value >= 0 ? "+" : "−"
        return "\(symbol)\(formatNumber(abs(value))) bpm"
    }
}
