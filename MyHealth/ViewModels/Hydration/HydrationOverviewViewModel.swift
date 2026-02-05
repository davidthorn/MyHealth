//
//  HydrationOverviewViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class HydrationOverviewViewModel: ObservableObject {
    @Published public private(set) var isAuthorized: Bool
    @Published public private(set) var window: HydrationWindow
    @Published public private(set) var samples: [NutritionSample]
    @Published public private(set) var todayTotalText: String
    @Published public private(set) var windowTotalText: String
    @Published public private(set) var windowAverageText: String
    @Published public private(set) var errorMessage: String?
    @Published public var isAddPresented: Bool

    private let service: HydrationOverviewServiceProtocol
    private var task: Task<Void, Never>?

    public init(service: HydrationOverviewServiceProtocol) {
        self.service = service
        self.isAuthorized = true
        self.window = .day
        self.samples = []
        self.todayTotalText = "—"
        self.windowTotalText = "—"
        self.windowAverageText = "—"
        self.errorMessage = nil
        self.isAddPresented = false
    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let service = self?.service else { return }
            let isAuthorized = await service.requestReadAuthorization()
            guard let self, !Task.isCancelled else { return }
            self.isAuthorized = isAuthorized
            guard isAuthorized else { return }
            self.startUpdates(with: service)
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
    }

    public func selectWindow(_ window: HydrationWindow) {
        self.window = window
        refresh()
    }

    public func refresh() {
        guard isAuthorized else { return }
        startUpdates(with: service)
    }

    private func startUpdates(with service: HydrationOverviewServiceProtocol) {
        task?.cancel()
        task = Task { [weak self] in
            guard let self else { return }
            for await update in service.updates(window: self.window) {
                guard !Task.isCancelled else { break }
                self.samples = update.samples
                self.todayTotalText = formatHydration(update.todayTotalMilliliters)
                self.windowTotalText = formatHydration(update.windowTotalMilliliters)
                self.windowAverageText = formatAverage(
                    total: update.windowTotalMilliliters,
                    days: update.window.days
                )
            }
        }
    }

    private func formatHydration(_ milliliters: Double?) -> String {
        guard let milliliters else { return "—" }
        if milliliters >= 1000 {
            let liters = milliliters / 1000
            return "\(formatNumber(liters)) L"
        }
        return "\(formatNumber(milliliters)) ml"
    }

    private func formatAverage(total: Double?, days: Int) -> String {
        guard let total, days > 0 else { return "—" }
        let average = total / Double(days)
        return formatHydration(average)
    }

    private func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = value >= 100 ? 0 : 1
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
