//
//  SleepReadingDetailViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import SwiftUI
import Models

@MainActor
public final class SleepReadingDetailViewModel: ObservableObject {
    @Published public private(set) var day: SleepDay?
    @Published public private(set) var entries: [SleepEntry]
    @Published public private(set) var isAuthorized: Bool

    private let service: SleepReadingDetailServiceProtocol
    private let date: Date
    private var task: Task<Void, Never>?

    public init(service: SleepReadingDetailServiceProtocol, date: Date) {
        self.service = service
        self.date = date
        self.day = nil
        self.entries = []
        self.isAuthorized = true
    }

    public var totalDurationText: String {
        guard let day else { return "—" }
        return formatDuration(day.durationSeconds)
    }

    public var categorySummaries: [SleepEntryCategorySummary] {
        guard !entries.isEmpty else { return [] }
        var totals: [SleepEntryCategory: TimeInterval] = [:]
        for entry in entries {
            totals[entry.category, default: 0] += entry.durationSeconds
        }
        return totals
            .map { SleepEntryCategorySummary(category: $0.key, durationSeconds: $0.value) }
            .sorted { $0.durationSeconds > $1.durationSeconds }
    }

    public var chartEntries: [SleepEntry] {
        entries.sorted { $0.startDate < $1.startDate }
    }

    public func stageColor(for category: SleepEntryCategory) -> Color {
        switch category {
        case .inBed:
            return .blue
        case .asleep:
            return .indigo
        case .asleepCore:
            return .teal
        case .asleepDeep:
            return .purple
        case .asleepREM:
            return .pink
        case .awake:
            return .orange
        }
    }

    public func formattedDateText() -> String {
        guard let day else { return "Sleep" }
        return day.date.formatted(date: .complete, time: .omitted)
    }

    public func formattedDuration(_ seconds: TimeInterval) -> String {
        formatDuration(seconds)
    }

    private func formatDuration(_ seconds: TimeInterval) -> String {
        let totalMinutes = Int(seconds / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
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
                self.entries = update.entries
            }
        }
    }
}
