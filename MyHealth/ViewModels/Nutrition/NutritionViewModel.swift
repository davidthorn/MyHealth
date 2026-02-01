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

    private let service: NutritionServiceProtocol
    private var task: Task<Void, Never>?

    public init(service: NutritionServiceProtocol) {
        self.service = service
        self.types = []
    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let service = self?.service else { return }
            for await update in service.updates() {
                guard let self, !Task.isCancelled else { break }
                self.types = update.types
            }
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
    }

    public func route(for type: NutritionType) -> NutritionRoute {
        .type(type)
    }
}
