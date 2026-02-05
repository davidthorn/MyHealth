//
//  HydrationOverviewServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HydrationOverviewServiceProtocol {
    func requestReadAuthorization() async -> Bool
    func updates(window: HydrationWindow) -> AsyncStream<HydrationOverviewUpdate>
}
