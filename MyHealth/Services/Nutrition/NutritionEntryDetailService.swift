//
//  NutritionEntryDetailService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

@MainActor
public final class NutritionEntryDetailService: NutritionEntryDetailServiceProtocol {
    private let mutatingService: NutritionEntryMutating

    public init(mutatingService: NutritionEntryMutating) {
        self.mutatingService = mutatingService
    }

    public func updates(for sample: NutritionSample) -> AsyncStream<NutritionEntryDetailUpdate> {
        AsyncStream { continuation in
            let task = Task {
                guard !Task.isCancelled else {
                    continuation.finish()
                    return
                }
                continuation.yield(NutritionEntryDetailUpdate(sample: sample))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    public func save(sample: NutritionSample) async throws {
        try await mutatingService.save(sample: sample)
    }

    public func delete(id: UUID) async throws {
        try await mutatingService.delete(id: id)
    }
}
