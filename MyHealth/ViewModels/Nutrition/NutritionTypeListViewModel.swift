//
//  NutritionTypeListViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class NutritionTypeListViewModel: ObservableObject {
    @Published public private(set) var type: NutritionType
    @Published public private(set) var samples: [NutritionSample]

    private let service: NutritionTypeListServiceProtocol
    private var task: Task<Void, Never>?

    public init(service: NutritionTypeListServiceProtocol, type: NutritionType) {
        self.service = service
        self.type = type
        self.samples = []
    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let service = self?.service, let type = self?.type else { return }
            let isAuthorized = await service.requestAuthorization(type: type)
            guard isAuthorized, !Task.isCancelled else { return }
            for await update in service.updates(for: type) {
                guard let self, !Task.isCancelled else { break }
                self.type = update.type
                self.samples = update.samples
            }
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
    }
}
