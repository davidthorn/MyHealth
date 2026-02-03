//
//  BloodOxygenDetailViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class BloodOxygenDetailViewModel: ObservableObject {
    @Published public private(set) var readings: [BloodOxygenReading]
    @Published public private(set) var isAuthorized: Bool
    @Published public var selectedWindow: BloodOxygenWindow

    private let service: BloodOxygenDetailServiceProtocol
    private var task: Task<Void, Never>?
    private var readingsTask: Task<Void, Never>?

    public let windows: [BloodOxygenWindow]

    public init(service: BloodOxygenDetailServiceProtocol) {
        self.service = service
        self.readings = []
        self.isAuthorized = false
        self.selectedWindow = .day
        self.windows = BloodOxygenWindow.allCases
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

    public func selectWindow(_ window: BloodOxygenWindow) {
        selectedWindow = window
        guard isAuthorized else { return }
        startReadingsStream(for: window)
    }

    public var latestReading: BloodOxygenReading? {
        readings.sorted { $0.endDate > $1.endDate }.first
    }

    public var averageText: String {
        guard !readings.isEmpty else { return "—" }
        let average = readings.map(\.percent).reduce(0, +) / Double(readings.count)
        return formatPercent(average)
    }

    public var minText: String {
        guard let value = readings.map(\.percent).min() else { return "—" }
        return formatPercent(value)
    }

    public var maxText: String {
        guard let value = readings.map(\.percent).max() else { return "—" }
        return formatPercent(value)
    }

    public func percentText(for reading: BloodOxygenReading) -> String {
        formatPercent(reading.percent)
    }

    public func dateText(for reading: BloodOxygenReading) -> String {
        reading.endDate.formatted(date: .abbreviated, time: .shortened)
    }

    public func chartReadings() -> [BloodOxygenReading] {
        readings.sorted { $0.endDate < $1.endDate }
    }

    private func startReadingsStream(for window: BloodOxygenWindow) {
        readingsTask?.cancel()
        readingsTask = Task { [weak self] in
            guard let service = self?.service else { return }
            for await update in service.updates(window: window) {
                guard let self, !Task.isCancelled else { break }
                self.readings = update.readings
            }
        }
    }

    private func formatPercent(_ value: Double) -> String {
        "\(value.formatted(.number.precision(.fractionLength(1))))%"
    }
}
