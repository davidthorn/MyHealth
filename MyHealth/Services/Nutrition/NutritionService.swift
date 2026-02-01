//
//  NutritionService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

@MainActor
public final class NutritionService: NutritionServiceProtocol {
    public init() {}

    public func updates() -> AsyncStream<NutritionUpdate> {
        AsyncStream { continuation in
            let task = Task {
                guard !Task.isCancelled else {
                    continuation.finish()
                    return
                }
                continuation.yield(NutritionUpdate(types: NutritionType.allCases))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
