//
//  HealthKitStandHoursAdapterProtocol.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthKitStandHoursAdapterProtocol {
    func requestAuthorization() async -> Bool
    func standHoursSummaryStream(days: Int) -> AsyncStream<StandHoursSummary>
}
