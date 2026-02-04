//
//  HeartRateVariabilityDetailViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class HeartRateVariabilityDetailViewModel: ObservableObject {
    @Published public private(set) var readings: [HeartRateVariabilityReading]
    @Published public private(set) var dayStats: [HeartRateVariabilityDayStats]
    @Published public private(set) var isAuthorized: Bool
    @Published public var selectedWindow: HeartRateVariabilityWindow

    private let service: HeartRateVariabilityDetailServiceProtocol
    private var task: Task<Void, Never>?
    private var readingsTask: Task<Void, Never>?

    public let windows: [HeartRateVariabilityWindow]

    public init(service: HeartRateVariabilityDetailServiceProtocol) {
        self.service = service
        self.readings = []
        self.dayStats = []
        self.isAuthorized = false
        self.selectedWindow = .day
        self.windows = HeartRateVariabilityWindow.allCases
    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let service = self?.service else { return }
            let isAuthorized = await service.requestAuthorization()
            guard !Task.isCancelled else { return }
            guard let self else { return }
            self.isAuthorized = isAuthorized
            if isAuthorized {
                self.startReadingsStream(for: self.selectedWindow)
            }
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
        readingsTask?.cancel()
        readingsTask = nil
    }

    public func requestAuthorization() {
        task?.cancel()
        task = nil
        start()
    }

    public func selectWindow(_ window: HeartRateVariabilityWindow) {
        selectedWindow = window
        guard isAuthorized else { return }
        startReadingsStream(for: window)
    }

    public var latestReading: HeartRateVariabilityReading? {
        readings.sorted { $0.endDate > $1.endDate }.first
    }

    public var averageText: String {
        guard !readings.isEmpty else { return "—" }
        let average = readings.map(\.milliseconds).reduce(0, +) / Double(readings.count)
        return formatMilliseconds(average)
    }

    public var minText: String {
        guard let value = readings.map(\.milliseconds).min() else { return "—" }
        return formatMilliseconds(value)
    }

    public var maxText: String {
        guard let value = readings.map(\.milliseconds).max() else { return "—" }
        return formatMilliseconds(value)
    }

    public func millisecondsText(for reading: HeartRateVariabilityReading) -> String {
        formatMilliseconds(reading.milliseconds)
    }

    public func dateText(for reading: HeartRateVariabilityReading) -> String {
        reading.endDate.formatted(date: .abbreviated, time: .shortened)
    }

    public func timeText(for reading: HeartRateVariabilityReading) -> String {
        reading.endDate.formatted(date: .omitted, time: .shortened)
    }

    public func dayTitle(for date: Date) -> String {
        date.formatted(date: .abbreviated, time: .omitted)
    }

    public func status(for reading: HeartRateVariabilityReading) -> HeartRateVariabilityStatus {
        let average = averageValue
        guard average > 0 else { return .normal }
        if reading.milliseconds >= average * 1.1 {
            return .high
        }
        if reading.milliseconds <= average * 0.9 {
            return .low
        }
        return .normal
    }

    public func daySummary(for date: Date) -> (average: String, min: String, max: String) {
        let key = Calendar.current.startOfDay(for: date)
        guard let stats = groupedDayStats[key] else { return ("—", "—", "—") }
        let average = stats.averageMilliseconds.map(formatMilliseconds) ?? "—"
        let minValue = stats.minMilliseconds.map(formatMilliseconds) ?? "—"
        let maxValue = stats.maxMilliseconds.map(formatMilliseconds) ?? "—"
        return (average, minValue, maxValue)
    }

    public var groupedReadings: [(date: Date, readings: [HeartRateVariabilityReading])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: readings) { calendar.startOfDay(for: $0.endDate) }
        return grouped
            .map { ($0.key, $0.value.sorted { $0.endDate > $1.endDate }) }
            .sorted { $0.date > $1.date }
    }

    public var groupedDayStats: [Date: HeartRateVariabilityDayStats] {
        let calendar = Calendar.current
        return Dictionary(uniqueKeysWithValues: dayStats.map {
            (calendar.startOfDay(for: $0.date), $0)
        })
    }

    public func chartReadings() -> [HeartRateVariabilityReading] {
        readings.sorted { $0.endDate < $1.endDate }
    }

    private func startReadingsStream(for window: HeartRateVariabilityWindow) {
        readingsTask?.cancel()
        readingsTask = Task { [weak self] in
            guard let service = self?.service else { return }
            for await update in service.updates(window: window) {
                guard let self, !Task.isCancelled else { break }
                self.readings = update.readings
                self.dayStats = update.dayStats
            }
        }
    }

    private func formatMilliseconds(_ value: Double) -> String {
        "\(value.formatted(.number.precision(.fractionLength(0)))) ms"
    }

    private var averageValue: Double {
        guard !readings.isEmpty else { return 0 }
        return readings.map(\.milliseconds).reduce(0, +) / Double(readings.count)
    }
}
