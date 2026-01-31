//
//  RestingHeartRateDayDetailViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class RestingHeartRateDayDetailViewModel: ObservableObject {
    @Published public private(set) var readings: [RestingHeartRateReading]
    @Published public private(set) var isAuthorized: Bool
    @Published public private(set) var rangePointsByReadingId: [UUID: [HeartRateRangePoint]]

    public let date: Date

    private let service: RestingHeartRateDayDetailServiceProtocol
    private var task: Task<Void, Never>?
    private var rangeTasks: [UUID: Task<Void, Never>]

    public init(service: RestingHeartRateDayDetailServiceProtocol, date: Date) {
        self.service = service
        self.date = date
        self.readings = []
        self.isAuthorized = true
        self.rangePointsByReadingId = [:]
        self.rangeTasks = [:]
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
        rangeTasks.values.forEach { $0.cancel() }
        rangeTasks = [:]
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

    private func startUpdates(with service: RestingHeartRateDayDetailServiceProtocol) {
        guard task == nil else { return }
        let targetDate = date
        task = Task { [weak self] in
            for await update in service.updates(for: targetDate) {
                guard let self, !Task.isCancelled else { break }
                self.readings = update.readings
            }
        }
    }

    public func rangePoints(for reading: RestingHeartRateReading) -> [HeartRateRangePoint] {
        rangePointsByReadingId[reading.id] ?? []
    }

    public func loadRange(for reading: RestingHeartRateReading) {
        let readingId = reading.id
        guard rangeTasks[readingId] == nil, rangePointsByReadingId[readingId] == nil else { return }
        let startDate = reading.startDate
        let endDate = reading.endDate
        rangeTasks[readingId] = Task { [weak self] in
            guard let service = self?.service, !Task.isCancelled else { return }
            for await readings in service.rangeUpdates(start: startDate, end: endDate) {
                guard let self, !Task.isCancelled else { break }
                let points = Self.buildRangePoints(from: readings)
                self.rangePointsByReadingId[readingId] = points
            }
            self?.rangeTasks[readingId] = nil
        }
    }

    private static func buildRangePoints(from readings: [HeartRateReading]) -> [HeartRateRangePoint] {
        guard !readings.isEmpty else { return [] }
        let calendar = Calendar.current
        var buckets: [Date: [Double]] = [:]
        for reading in readings {
            let bucketDate = calendar.date(bySetting: .second, value: 0, of: reading.date) ?? reading.date
            buckets[bucketDate, default: []].append(reading.bpm)
        }
        let points = buckets.map { (date, values) -> HeartRateRangePoint in
            let average = values.reduce(0, +) / Double(values.count)
            return HeartRateRangePoint(date: date, bpm: average)
        }
        return points.sorted { $0.date < $1.date }
    }
}
