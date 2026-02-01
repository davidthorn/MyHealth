//
//  MetricsViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class MetricsViewModel: ObservableObject {
    @Published public private(set) var title: String
    @Published public var selectedRange: String
    @Published public var selectedMetric: MetricsCategory
    @Published public private(set) var restingHeartRateSummary: RestingHeartRateSummary?
    @Published public private(set) var lastUpdated: Date?
    @Published public private(set) var summaryCards: [(category: MetricsCategory, value: String, subtitle: String, trend: String)]
    @Published public private(set) var statItems: [(title: String, value: String)]
    @Published public private(set) var insights: [(title: String, detail: String)]
    @Published public private(set) var nutritionSummary: NutritionDaySummary?

    private let service: MetricsServiceProtocol
    private var task: Task<Void, Never>?

    public let ranges: [String]
    public let metrics: [MetricsCategory]
    public init(service: MetricsServiceProtocol) {
        self.service = service
        self.title = "Metrics"
        self.ranges = ["Day", "Week", "Month"]
        self.metrics = MetricsCategory.allCases
        self.selectedRange = "Day"
        self.selectedMetric = .heartRate
        self.restingHeartRateSummary = nil
        self.lastUpdated = nil
        self.summaryCards = []
        self.statItems = []
        self.insights = []
        self.nutritionSummary = nil
    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let service = self?.service else { return }
            for await update in service.updates() {
                guard let self, !Task.isCancelled else { break }
                self.title = update.title
                self.restingHeartRateSummary = update.restingHeartRateSummary
                self.lastUpdated = Date()
                self.summaryCards = self.buildSummaryCards(from: update)
                self.statItems = self.buildStatItems(from: update)
                self.insights = self.buildInsights(from: update)
                self.nutritionSummary = update.nutritionSummary
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

    public func latestRestingHeartRatePoints() -> [HeartRateRangePoint] {
        guard let summary = restingHeartRateSummary else { return [] }
        let days = summary.previous + (summary.latest.map { [$0] } ?? [])
        return days.sorted { $0.date < $1.date }.map { day in
            HeartRateRangePoint(date: day.date, bpm: day.averageBpm)
        }
    }

    private func buildSummaryCards(from update: MetricsUpdate) -> [(category: MetricsCategory, value: String, subtitle: String, trend: String)] {
        var cards: [(category: MetricsCategory, value: String, subtitle: String, trend: String)] = []

        let latestStepsCount = update.stepsSummary?.latest?.count
        let previousStepsCount = update.stepsSummary?.previous.first?.count
        let latestFlightsCount = update.flightsSummary?.latest?.count
        let previousFlightsCount = update.flightsSummary?.previous.first?.count
        let latestStandCount = update.standHoursSummary?.latest?.count
        let previousStandCount = update.standHoursSummary?.previous.first?.count

        cards.append(
            summaryCard(
                category: .heartRate,
                latestValue: update.heartRateSummary?.latest?.bpm,
                previousValue: update.heartRateSummary?.previous.first?.bpm,
                unit: "bpm",
                subtitle: "Latest"
            )
        )
        cards.append(
            summaryCard(
                category: .restingHeartRate,
                latestValue: update.restingHeartRateSummary?.latest?.averageBpm,
                previousValue: update.restingHeartRateSummary?.previous.first?.averageBpm,
                unit: "bpm",
                subtitle: "Today"
            )
        )
        cards.append(
            summaryCard(
                category: .steps,
                latestValue: latestStepsCount.map(Double.init),
                previousValue: previousStepsCount.map(Double.init),
                unit: nil,
                subtitle: "Today"
            )
        )
        cards.append(
            summaryCard(
                category: .flights,
                latestValue: latestFlightsCount.map(Double.init),
                previousValue: previousFlightsCount.map(Double.init),
                unit: nil,
                subtitle: "Today"
            )
        )
        cards.append(
            summaryCard(
                category: .standHours,
                latestValue: latestStandCount.map(Double.init),
                previousValue: previousStandCount.map(Double.init),
                unit: "hr",
                subtitle: "Today"
            )
        )
        cards.append(
            summaryCard(
                category: .calories,
                latestValue: update.caloriesSummary?.latest?.activeKilocalories,
                previousValue: update.caloriesSummary?.previous.first?.activeKilocalories,
                unit: "kcal",
                subtitle: "Active"
            )
        )
        cards.append(
            summaryCard(
                category: .sleep,
                latestValue: update.sleepSummary?.latest?.durationSeconds,
                previousValue: update.sleepSummary?.previous.first?.durationSeconds,
                unit: nil,
                subtitle: "Last night",
                formatter: formatDuration
            )
        )
        cards.append(
            summaryCard(
                category: .activityRings,
                value: activityRingsValue(for: update.activityRingsSummary?.latest),
                subtitle: "Today",
                trend: activityRingsTrend(latest: update.activityRingsSummary?.latest)
            )
        )

        return cards
    }

    private func buildStatItems(from update: MetricsUpdate) -> [(title: String, value: String)] {
        let readings = (update.heartRateSummary?.latest.map { [$0] } ?? []) + (update.heartRateSummary?.previous ?? [])
        let latestBpm = update.heartRateSummary?.latest?.bpm
        let maxBpm = readings.map(\.bpm).max()
        let minBpm = readings.map(\.bpm).min()
        let restingBpm = update.restingHeartRateSummary?.latest?.averageBpm
        let rangeValue: String
        if let minBpm, let maxBpm {
            rangeValue = "\(formatNumber(minBpm))–\(formatNumber(maxBpm)) bpm"
        } else {
            rangeValue = "—"
        }
        return [
            ("Average", latestBpm.map { "\(formatNumber($0)) bpm" } ?? "—"),
            ("Peak", maxBpm.map { "\(formatNumber($0)) bpm" } ?? "—"),
            ("Resting", restingBpm.map { "\(formatNumber($0)) bpm" } ?? "—"),
            ("Range", rangeValue)
        ]
    }

    private func buildInsights(from update: MetricsUpdate) -> [(title: String, detail: String)] {
        var items: [(String, String)] = []
        if update.restingHeartRateSummary?.latest != nil {
            items.append(("Resting heart rate", "Latest resting heart rate has been recorded for today."))
        }
        if update.stepsSummary?.latest != nil {
            items.append(("Steps", "Step count data is available for today."))
        }
        if items.isEmpty {
            items.append(("No insights yet", "Connect Health to see personalized trends."))
        }
        return items
    }

    private func summaryCard(
        category: MetricsCategory,
        latestValue: Double?,
        previousValue: Double?,
        unit: String?,
        subtitle: String,
        formatter: ((Double) -> String)? = nil
    ) -> (category: MetricsCategory, value: String, subtitle: String, trend: String) {
        let value: String
        if let latestValue {
            if let formatter {
                value = formatter(latestValue)
            } else if let unit {
                value = "\(formatNumber(latestValue)) \(unit)"
            } else {
                value = formatNumber(latestValue)
            }
        } else {
            value = "—"
        }
        let trend = trendString(latest: latestValue, previous: previousValue, unit: unit)
        return (category: category, value: value, subtitle: subtitle, trend: trend)
    }

    private func summaryCard(
        category: MetricsCategory,
        value: String,
        subtitle: String,
        trend: String
    ) -> (category: MetricsCategory, value: String, subtitle: String, trend: String) {
        (category: category, value: value, subtitle: subtitle, trend: trend)
    }

    private func trendString(latest: Double?, previous: Double?, unit: String?) -> String {
        guard let latest, let previous else { return "—" }
        let delta = latest - previous
        let symbol = delta >= 0 ? "▲" : "▼"
        let absDelta = abs(delta)
        let deltaText = formatNumber(absDelta)
        if let unit {
            return "\(symbol) \(deltaText) \(unit)"
        }
        return "\(symbol) \(deltaText)"
    }

    private func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value.rounded())) ?? "\(Int(value.rounded()))"
    }

    private func formatDuration(_ seconds: Double) -> String {
        let totalMinutes = Int(seconds / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }

    private func activityRingsValue(for day: ActivityRingsDay?) -> String {
        guard let day else { return "—" }
        let closed = [
            day.moveValue >= day.moveGoal,
            day.exerciseMinutes >= day.exerciseGoal,
            day.standHours >= day.standGoal
        ].filter { $0 }.count
        return "\(closed)/3"
    }

    private func activityRingsTrend(latest: ActivityRingsDay?) -> String {
        guard let latest else { return "—" }
        let closed = [
            latest.moveValue >= latest.moveGoal,
            latest.exerciseMinutes >= latest.exerciseGoal,
            latest.standHours >= latest.standGoal
        ].filter { $0 }.count
        return "Closed \(closed) ring" + (closed == 1 ? "" : "s")
    }
}
