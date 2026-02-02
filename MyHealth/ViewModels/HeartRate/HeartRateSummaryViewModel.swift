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
    @Published public private(set) var dayPoints: [HeartRateRangePoint]

    private let service: HeartRateSummaryServiceProtocol
    private var task: Task<Void, Never>?
    private var dayTask: Task<Void, Never>?

    public init(service: HeartRateSummaryServiceProtocol) {
        self.service = service
        self.summary = nil
        self.isAuthorized = true
        self.dayPoints = []
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
            self?.refreshDayReadings()
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
        dayTask?.cancel()
        dayTask = nil
    }

    public func requestAuthorization() {
        Task { [weak self] in
            guard let service = self?.service, !Task.isCancelled else { return }
            let isAuthorized = await service.requestAuthorization()
            guard !Task.isCancelled else { return }
            self?.isAuthorized = isAuthorized
            if isAuthorized {
                self?.startUpdates(with: service)
                self?.refreshDayReadings()
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

    public var dayAverageText: String? {
        guard let summary, let average = summary.averageBpm else { return nil }
        return "\(formatNumber(average)) bpm"
    }

    public var latestTimeText: String? {
        summary?.latest?.date.formatted(date: .abbreviated, time: .shortened)
    }

    private func startUpdates(with service: HeartRateSummaryServiceProtocol) {
        guard task == nil else { return }
        task = Task { [weak self] in
            for await update in service.updates() {
                guard let self, !Task.isCancelled else { break }
                self.summary = update.summary
                self.refreshDayReadings()
            }
        }
    }

    private func refreshDayReadings() {
        dayTask?.cancel()
        dayTask = Task { [weak self] in
            guard let self else { return }
            let start = Calendar.current.startOfDay(for: Date())
            let end = Date()
            let readings = await service.dayReadings(start: start, end: end)
            guard !Task.isCancelled else { return }
            let points = readings.sorted { $0.date < $1.date }.map {
                HeartRateRangePoint(date: $0.date, bpm: $0.bpm)
            }
            self.dayPoints = points
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
