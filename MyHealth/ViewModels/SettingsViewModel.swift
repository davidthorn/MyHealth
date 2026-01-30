//
//  SettingsViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation

@MainActor
public final class SettingsViewModel: ObservableObject {
    @Published public private(set) var title: String
    @Published public var path: [SettingsRoute]

    private let service: SettingsServiceProtocol
    private var task: Task<Void, Never>?

    public init(service: SettingsServiceProtocol) {
        self.service = service
        self.title = "Settings"
        self.path = []

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
}
