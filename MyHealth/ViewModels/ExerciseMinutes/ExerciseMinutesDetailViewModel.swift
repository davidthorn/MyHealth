//
//  ExerciseMinutesDetailViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class ExerciseMinutesDetailViewModel: ObservableObject {
    @Published public private(set) var days: [ExerciseMinutesDayDetail]
    @Published public private(set) var isAuthorized: Bool
    @Published public var selectedWindow: ExerciseMinutesWindow

    private let service: ExerciseMinutesDetailServiceProtocol
    private var task: Task<Void, Never>?
    private var updatesTask: Task<Void, Never>?

    public let windows: [ExerciseMinutesWindow]

    public init(service: ExerciseMinutesDetailServiceProtocol) {
        self.service = service
        self.days = []
        self.isAuthorized = false
        self.selectedWindow = .day
        self.windows = ExerciseMinutesWindow.allCases
    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let service = self?.service else { return }
            let authorized = await service.requestAuthorization()
            guard !Task.isCancelled else { return }
            guard let self else { return }
            self.isAuthorized = authorized
            if authorized {
                self.startUpdates(for: self.selectedWindow)
            }
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
        updatesTask?.cancel()
        updatesTask = nil
    }

    public func requestAuthorization() {
        task?.cancel()
        task = nil
        start()
    }

    public func selectWindow(_ window: ExerciseMinutesWindow) {
        selectedWindow = window
        guard isAuthorized else { return }
        startUpdates(for: window)
    }

    public var totalText: String {
        let total = days.reduce(0) { $0 + $1.minutes }
        return formatMinutes(total)
    }

    public var averageText: String {
        guard selectedWindow != .day else { return totalText }
        let total = days.reduce(0) { $0 + $1.minutes }
        let average = total / Double(selectedWindow.days)
        return formatMinutes(average)
    }

    public var displayTitle: String {
        selectedWindow == .day ? "Total" : "Daily Average"
    }

    public var sortedDays: [ExerciseMinutesDayDetail] {
        days.sorted { $0.date < $1.date }
    }

    public func minutesText(for day: ExerciseMinutesDayDetail) -> String {
        formatMinutes(day.minutes)
    }

    private func startUpdates(for window: ExerciseMinutesWindow) {
        updatesTask?.cancel()
        updatesTask = Task { [weak self] in
            guard let service = self?.service else { return }
            for await update in service.updates(window: window) {
                guard let self, !Task.isCancelled else { break }
                self.days = update.days
            }
        }
    }

    private func formatMinutes(_ minutes: Double) -> String {
        "\(minutes.formatted(.number.precision(.fractionLength(0)))) min"
    }
}
