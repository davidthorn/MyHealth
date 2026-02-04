//
//  CardioFitnessDetailServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol CardioFitnessDetailServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates(window: CardioFitnessWindow) -> AsyncStream<CardioFitnessDetailUpdate>
}
