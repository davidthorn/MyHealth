//
//  MetricsViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation

@MainActor
public final class MetricsViewModel: ObservableObject {
    @Published public private(set) var title: String
    @Published public var selectedRange: String
    @Published public var selectedMetric: MetricsCategory

    private let service: MetricsServiceProtocol
    private var task: Task<Void, Never>?

    public let ranges: [String]
    public let metrics: [MetricsCategory]
    public let summaryCards: [(category: MetricsCategory, value: String, subtitle: String, trend: String)]
    public let statItems: [(title: String, value: String)]
    public let insights: [(title: String, detail: String)]

    public init(service: MetricsServiceProtocol) {
        self.service = service
        self.title = "Metrics"
        self.ranges = ["Day", "Week", "Month"]
        self.metrics = MetricsCategory.allCases
        self.selectedRange = "Day"
        self.selectedMetric = .heartRate
        self.summaryCards = [
            (.heartRate, "72 bpm", "Avg today", "▼ 3 bpm"),
            (.restingHeartRate, "58 bpm", "Today", "▼ 2 bpm"),
            (.steps, "8,420", "Today", "▲ 6%"),
            (.flights, "12", "Today", "▲ 2%"),
            (.standHours, "8", "Today", "▲ 1"),
            (.calories, "520", "Active", "▲ 4%"),
            (.sleep, "7h 42m", "Last night", "▲ 12m"),
            (.activityRings, "3/3", "Closed today", "▲ 1 ring")
        ]
        self.statItems = [
            ("Average", "72 bpm"),
            ("Peak", "128 bpm"),
            ("Resting", "60 bpm"),
            ("Range", "62–118 bpm")
        ]
        self.insights = [
            ("Trend improving", "Your resting heart rate is 3 bpm lower than last week."),
            ("High effort window", "Peak heart rate occurred between 6–7 PM."),
            ("Consistency", "You hit your activity goal 5 days in a row.")
        ]
    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let service = self?.service else { return }
            for await update in service.updates() {
                guard let self, !Task.isCancelled else { break }
                self.title = update.title
            }
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
    }

    public func selectRange(_ range: String) {
        selectedRange = range
    }

    public func selectMetric(_ metric: MetricsCategory) {
        selectedMetric = metric
    }

    public func metricRoute() -> MetricsRoute {
        .metric(selectedMetric)
    }

    public func route(for category: MetricsCategory) -> MetricsRoute {
        .metric(category)
    }
}
