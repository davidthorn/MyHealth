//
//  ActivityRingsMetricDayDetailViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models
import SwiftUI

@MainActor
public final class ActivityRingsMetricDayDetailViewModel: ObservableObject {
    @Published public private(set) var day: ActivityRingsDay?
    @Published public private(set) var isAuthorized: Bool

    public let metric: ActivityRingsMetric

    private let service: ActivityRingsMetricDayDetailServiceProtocol
    private let date: Date
    private var task: Task<Void, Never>?

    public init(service: ActivityRingsMetricDayDetailServiceProtocol, metric: ActivityRingsMetric, date: Date) {
        self.service = service
        self.metric = metric
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

    public var dateTitle: String {
        guard let day else { return "" }
        return day.date.formatted(.dateTime.day().month().year())
    }

    public var valueText: String {
        guard let day else { return "--" }
        return "\(metricValue(for: day)) \(metric.unit)"
    }

    public var goalText: String {
        guard let day else { return "--" }
        return "Goal \(metricGoal(for: day))"
    }

    public var progress: Double {
        guard let day else { return 0 }
        return metricProgress(for: day)
    }

    public var metricColor: Color {
        switch metric {
        case .move:
            return .pink
        case .exercise:
            return .green
        case .stand:
            return .blue
        }
    }

    private func startUpdates(with service: ActivityRingsMetricDayDetailServiceProtocol) {
        guard task == nil else { return }
        let mDate = date
        task = Task { [weak self] in
            for await update in service.updates(for: mDate) {
                guard let self, !Task.isCancelled else { break }
                self.day = update.day
            }
        }
    }

    private func metricValue(for day: ActivityRingsDay) -> Int {
        switch metric {
        case .move:
            return Int(day.moveValue.rounded())
        case .exercise:
            return Int(day.exerciseMinutes.rounded())
        case .stand:
            return Int(day.standHours.rounded())
        }
    }

    private func metricGoal(for day: ActivityRingsDay) -> Int {
        switch metric {
        case .move:
            return Int(day.moveGoal.rounded())
        case .exercise:
            return Int(day.exerciseGoal.rounded())
        case .stand:
            return Int(day.standGoal.rounded())
        }
    }

    private func metricProgress(for day: ActivityRingsDay) -> Double {
        switch metric {
        case .move:
            return day.moveProgress
        case .exercise:
            return day.exerciseProgress
        case .stand:
            return day.standProgress
        }
    }
}
