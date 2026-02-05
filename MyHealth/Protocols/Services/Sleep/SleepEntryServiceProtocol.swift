//
//  SleepEntryServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol SleepEntryServiceProtocol {
    func requestReadAuthorization() async -> Bool
    func requestWriteAuthorization() async -> Bool
    func entries(days: Int) -> AsyncStream<[SleepEntry]>
    func saveSleepEntry(_ entry: SleepEntry) async throws
}
