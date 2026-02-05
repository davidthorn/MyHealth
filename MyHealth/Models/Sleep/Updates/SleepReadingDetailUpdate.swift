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
    public let entries: [SleepEntry]

    public init(day: SleepDay, entries: [SleepEntry]) {
        self.day = day
        self.entries = entries
    }
}
