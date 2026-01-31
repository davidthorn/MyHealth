//
//  SleepReadingDetailServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol SleepReadingDetailServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates(for date: Date) -> AsyncStream<SleepReadingDetailUpdate>
}
