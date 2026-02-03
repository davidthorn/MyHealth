//
//  ExerciseMinutesDetailServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol ExerciseMinutesDetailServiceProtocol {
    func requestAuthorization() async -> Bool
    func updates(window: ExerciseMinutesWindow) -> AsyncStream<ExerciseMinutesDetailUpdate>
}
