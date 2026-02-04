//
//  CardioFitnessDetailViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class CardioFitnessDetailViewModel: ObservableObject {
    @Published public private(set) var readings: [CardioFitnessReading]
    @Published public private(set) var dayStats: [CardioFitnessDayStats]
    @Published public private(set) var isAuthorized: Bool
    @Published public var selectedWindow: CardioFitnessWindow

    private let service: CardioFitnessDetailServiceProtocol
    private var task: Task<Void, Never>?
    private var readingsTask: Task<Void, Never>?

    public let windows: [CardioFitnessWindow]

    public init(service: CardioFitnessDetailServiceProtocol) {
        self.service = service
        self.readings = []
        self.dayStats = []
        self.isAuthorized = false
        self.selectedWindow = .day
        self.windows = CardioFitnessWindow.allCases
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

    public func selectWindow(_ window: CardioFitnessWindow) {
        selectedWindow = window
        guard isAuthorized else { return }
        startReadingsStream(for: window)
    }

    public var latestReading: CardioFitnessReading? {
        readings.sorted { $0.endDate > $1.endDate }.first
    }

    public var unitText: String {
        "ml/kg/min"
    }

    public var averageText: String {
        guard !readings.isEmpty else { return "—" }
        let average = readings.map(\.vo2Max).reduce(0, +) / Double(readings.count)
        return formatVo2Value(average)
    }

    public var minText: String {
        guard let value = readings.map(\.vo2Max).min() else { return "—" }
        return formatVo2Value(value)
    }

    public var maxText: String {
        guard let value = readings.map(\.vo2Max).max() else { return "—" }
        return formatVo2Value(value)
    }

    public func vo2Text(for reading: CardioFitnessReading) -> String {
        formatVo2WithUnit(reading.vo2Max)
    }

    public func dateText(for reading: CardioFitnessReading) -> String {
        reading.endDate.formatted(date: .abbreviated, time: .shortened)
    }

    public func timeText(for reading: CardioFitnessReading) -> String {
        reading.endDate.formatted(date: .omitted, time: .shortened)
    }

    public func dayTitle(for date: Date) -> String {
        date.formatted(date: .abbreviated, time: .omitted)
    }

    public func level(for reading: CardioFitnessReading) -> CardioFitnessLevel {
        cardioFitnessLevel(value: reading.vo2Max)
    }

    public func daySummary(for date: Date) -> (average: String, min: String, max: String) {
        let key = Calendar.current.startOfDay(for: date)
        guard let stats = groupedDayStats[key] else { return ("—", "—", "—") }
        let average = stats.averageVo2Max.map(formatVo2Value) ?? "—"
        let minValue = stats.minVo2Max.map(formatVo2Value) ?? "—"
        let maxValue = stats.maxVo2Max.map(formatVo2Value) ?? "—"
        return (average, minValue, maxValue)
    }

    public var groupedReadings: [(date: Date, readings: [CardioFitnessReading])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: readings) { calendar.startOfDay(for: $0.endDate) }
        return grouped
            .map { ($0.key, $0.value.sorted { $0.endDate > $1.endDate }) }
            .sorted { $0.date > $1.date }
    }

    public var groupedDayStats: [Date: CardioFitnessDayStats] {
        let calendar = Calendar.current
        return Dictionary(uniqueKeysWithValues: dayStats.map {
            (calendar.startOfDay(for: $0.date), $0)
        })
    }

    public func chartReadings() -> [CardioFitnessReading] {
        readings.sorted { $0.endDate < $1.endDate }
    }

    private func startReadingsStream(for window: CardioFitnessWindow) {
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

    private func formatVo2Value(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(1)))
    }

    private func formatVo2WithUnit(_ value: Double) -> String {
        "\(formatVo2Value(value)) \(unitText)"
    }

    private func cardioFitnessLevel(value: Double) -> CardioFitnessLevel {
        switch value {
        case ..<25: return .low
        case ..<35: return .belowAverage
        case ..<45: return .average
        case ..<55: return .aboveAverage
        default: return .high
        }
    }
}
