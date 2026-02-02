//
//  HealthKitActiveEnergyAdapterProtocol.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthKitActiveEnergyAdapterProtocol {
    func requestAuthorization() async -> Bool
    func activeEnergySummaryStream(days: Int) -> AsyncStream<CaloriesSummary>
}
