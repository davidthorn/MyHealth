//
//  SleepReadingDetailUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct SleepReadingDetailUpdate: Sendable {
    public let day: SleepDay

    public init(day: SleepDay) {
        self.day = day
    }
}
