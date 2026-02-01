//
//  HeartRateReadingDetailService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor

@MainActor
public final class HeartRateReadingDetailService: HeartRateReadingDetailServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func requestAuthorization() async -> Bool {
        await healthKitAdapter.authorizationProvider.requestHeartRateAuthorization()
    }

    public func updates(for id: UUID) -> AsyncStream<HeartRateReadingDetailUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                do {
                    let reading = try await healthKitAdapter.heartRateReading(id: id)
                    guard !Task.isCancelled else { return }
                    continuation.yield(HeartRateReadingDetailUpdate(reading: reading))
                } catch {
                    continuation.finish()
                }
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
