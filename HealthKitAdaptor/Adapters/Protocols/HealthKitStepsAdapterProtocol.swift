//
//  HealthKitStepsAdapterProtocol.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthKitStepsAdapterProtocol: Sendable {
    func requestAuthorization() async -> Bool
    func stepsSummaryStream(days: Int) -> AsyncStream<StepsSummary>
}
