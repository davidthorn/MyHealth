//
//  NutritionViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class NutritionViewModel: ObservableObject {
    @Published public private(set) var types: [NutritionType]
    @Published public private(set) var summary: NutritionWindowSummary?
    @Published public var window: NutritionWindow

    private let service: NutritionServiceProtocol
    private var task: Task<Void, Never>?
    private var summaryTask: Task<Void, Never>?
    public let windows: [NutritionWindow]

    public init(service: NutritionServiceProtocol) {
        self.service = service
        self.types = []
        self.summary = nil
        self.window = .today
        self.windows = NutritionWindow.allCases
    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let service = self?.service else { return }
            for await update in service.updates() {
                guard let self, !Task.isCancelled else { break }
                self.types = update.types
                self.summary = update.summary
            }
        }
        refreshSummary()
    }

    public func stop() {
        task?.cancel()
        task = nil
        summaryTask?.cancel()
        summaryTask = nil
    }

    public func selectWindow(_ window: NutritionWindow) {
        self.window = window
        refreshSummary()
    }

    private func refreshSummary() {
        summaryTask?.cancel()
        summaryTask = Task { [weak self] in
            guard let service = self?.service, let window = self?.window else { return }
            for await summary in service.nutritionSummary(window: window) {
                guard let self, !Task.isCancelled else { break }
                self.summary = summary
            }
        }
    }

    public func route(for type: NutritionType) -> NutritionRoute {
        .type(type)
    }
}
