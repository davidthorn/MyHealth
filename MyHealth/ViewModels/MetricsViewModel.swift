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
    @Published public var selectedRange: MetricsRange
    @Published public var selectedMetric: MetricsCategory
    @Published public private(set) var restingHeartRateSummary: RestingHeartRateSummary?
    @Published public private(set) var lastUpdated: Date?
    @Published public private(set) var summaryCards: [MetricsSummaryCard]
    @Published public private(set) var statItems: [(title: String, value: String)]
    @Published public private(set) var insights: [(title: String, detail: String)]
    @Published public private(set) var nutritionSummary: NutritionWindowSummary?
    @Published public var nutritionWindow: NutritionWindow

    private let service: MetricsServiceProtocol
    private var task: Task<Void, Never>?
    private var nutritionTask: Task<Void, Never>?

    public let ranges: [MetricsRange]
    public let metrics: [MetricsCategory]
    public let nutritionWindows: [NutritionWindow]
    private let highlightCategories: Set<MetricsCategory>
    public init(service: MetricsServiceProtocol) {
        self.service = service
        self.title = "Metrics"
        self.ranges = MetricsRange.allCases
        self.metrics = MetricsCategory.allCases
        self.nutritionWindows = NutritionWindow.allCases
        self.selectedRange = .day
        self.selectedMetric = .heartRate
        self.restingHeartRateSummary = nil
        self.lastUpdated = nil
        self.summaryCards = []
        self.statItems = []
        self.insights = []
        self.nutritionSummary = nil
        self.nutritionWindow = .today
        self.highlightCategories = [.activityRings, .steps, .calories, .sleep]
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
                self.summaryCards = update.summaryCards()
                self.statItems = update.statItems()
                self.insights = update.insights()
                self.nutritionSummary = update.nutritionSummary
            }
        }
        refreshNutritionSummary()
    }

    public func stop() {
        task?.cancel()
        task = nil
        nutritionTask?.cancel()
        nutritionTask = nil
    }

    public func selectRange(_ range: MetricsRange) {
        selectedRange = range
    }

    public func selectMetric(_ metric: MetricsCategory) {
        selectedMetric = metric
    }

    public func selectNutritionWindow(_ window: NutritionWindow) {
        nutritionWindow = window
        refreshNutritionSummary()
    }

    public func metricRoute() -> MetricsRoute {
        .metric(selectedMetric)
    }

    public func route(for category: MetricsCategory) -> MetricsRoute {
        .metric(category)
    }

    public func latestRestingHeartRatePoints() -> [HeartRateRangePoint] {
        guard let summary = restingHeartRateSummary else { return [] }
        return summary.rangePoints()
    }

    public var highlightCards: [MetricsSummaryCard] {
        summaryCards.filter { highlightCategories.contains($0.category) }
    }

    public var otherCards: [MetricsSummaryCard] {
        summaryCards.filter { !highlightCategories.contains($0.category) }
    }

    private func refreshNutritionSummary() {
        nutritionTask?.cancel()
        nutritionTask = Task { [weak self] in
            guard let service = self?.service, let window = self?.nutritionWindow else { return }
            for await summary in service.nutritionSummary(window: window) {
                guard let self, !Task.isCancelled else { break }
                self.nutritionSummary = summary
            }
        }
    }
}
