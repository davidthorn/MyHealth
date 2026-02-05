//
//  TodayViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class TodayViewModel: ObservableObject {
    @Published public private(set) var title: String
    @Published public var path: [TodayRoute]
    @Published public private(set) var latestWorkout: TodayLatestWorkout?
    @Published public private(set) var activityRingsDay: ActivityRingsDay?
    @Published public private(set) var sleepDay: SleepDay?
    @Published public private(set) var restingHeartRateSummary: RestingHeartRateSummary?
    @Published public private(set) var heartRateVariabilitySummary: HeartRateVariabilitySummary?
    @Published public private(set) var heartRateSummary: HeartRateSummary?
    @Published public private(set) var stepsSummary: StepsSummary?
    @Published public private(set) var caloriesSummary: CaloriesSummary?
    @Published public private(set) var exerciseMinutesSummary: ExerciseMinutesSummary?
    @Published public private(set) var standHoursSummary: StandHoursSummary?
    @Published public private(set) var hydrationMilliliters: Double?

    private let service: TodayServiceProtocol
    private var task: Task<Void, Never>?

    public init(service: TodayServiceProtocol) {
        self.service = service
        self.title = "Today"
        self.path = []
        self.latestWorkout = nil
        self.activityRingsDay = nil
        self.sleepDay = nil
        self.restingHeartRateSummary = nil
        self.heartRateVariabilitySummary = nil
        self.heartRateSummary = nil
        self.stepsSummary = nil
        self.caloriesSummary = nil
        self.exerciseMinutesSummary = nil
        self.standHoursSummary = nil
        self.hydrationMilliliters = nil

    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let service = self?.service else { return }
            for await update in service.updates() {
                guard let self, !Task.isCancelled else { break }
                self.title = update.title
                self.latestWorkout = update.latestWorkout
                self.activityRingsDay = update.activityRingsDay
                self.sleepDay = update.sleepDay
                self.restingHeartRateSummary = update.restingHeartRateSummary
                self.heartRateVariabilitySummary = update.heartRateVariabilitySummary
                self.heartRateSummary = update.heartRateSummary
                self.stepsSummary = update.stepsSummary
                self.caloriesSummary = update.caloriesSummary
                self.exerciseMinutesSummary = update.exerciseMinutesSummary
                self.standHoursSummary = update.standHoursSummary
                self.hydrationMilliliters = update.hydrationMilliliters
            }
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
    }

    public var sleepDurationText: String {
        guard let sleepDay else { return "—" }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: sleepDay.durationSeconds) ?? "—"
    }

    public var restingHeartRateLatest: RestingHeartRateDay? {
        restingHeartRateSummary?.latest
    }

    public var restingHeartRateChartPoints: [HeartRateRangePoint] {
        restingHeartRateSummary?.rangePoints() ?? []
    }

    public var heartRateVariabilityLatest: HeartRateVariabilityReading? {
        heartRateVariabilitySummary?.latest
    }

    public var latestHeartRateText: String {
        guard let bpm = heartRateSummary?.latest?.bpm else { return "—" }
        return "\(formatNumber(Double(bpm))) bpm"
    }

    public var stepsText: String {
        guard let steps = stepsSummary?.latest?.count else { return "—" }
        return formatNumber(Double(steps))
    }

    public var caloriesText: String {
        guard let calories = caloriesSummary?.latest?.activeKilocalories else { return "—" }
        return "\(formatNumber(calories)) kcal"
    }

    public var exerciseMinutesText: String {
        guard let minutes = exerciseMinutesSummary?.latest?.minutes else { return "—" }
        return "\(formatNumber(minutes)) min"
    }

    public var standHoursText: String {
        guard let hours = standHoursSummary?.latest?.count else { return "—" }
        return "\(formatNumber(Double(hours))) hr"
    }

    public var hydrationText: String {
        guard let hydrationMilliliters else { return "—" }
        if hydrationMilliliters >= 1000 {
            let liters = hydrationMilliliters / 1000
            return "\(formatNumber(liters)) L"
        }
        return "\(formatNumber(hydrationMilliliters)) ml"
    }

    private func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = value >= 100 ? 0 : 1
        return formatter.string(from: NSNumber(value: value)) ?? "\(Int(value.rounded()))"
    }
}
