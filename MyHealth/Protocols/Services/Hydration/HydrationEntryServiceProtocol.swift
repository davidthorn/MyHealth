//
//  HydrationEntryServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol HydrationEntryServiceProtocol {
    func requestWriteAuthorization() async -> Bool
    func saveHydration(amountMilliliters: Double, date: Date) async throws
}
