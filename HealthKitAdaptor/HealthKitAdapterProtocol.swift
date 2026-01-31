//
//  HealthKitAdapterProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthKitAdapterProtocol {
    func requestAuthorization() async -> Bool
    func workoutsStream() -> AsyncStream<[Workout]>
}
