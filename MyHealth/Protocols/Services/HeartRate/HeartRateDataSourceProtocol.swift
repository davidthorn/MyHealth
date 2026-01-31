//
//  HeartRateDataSourceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HeartRateDataSourceProtocol {
    func requestAuthorization() async -> Bool
    func heartRateReadings(from start: Date, to end: Date) async -> [HeartRateReading]
}
