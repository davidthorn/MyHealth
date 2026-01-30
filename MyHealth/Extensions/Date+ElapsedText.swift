//
//  Date+ElapsedText.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public extension Date {
    func elapsedText(to end: Date = Date()) -> String {
        let elapsed = Int(end.timeIntervalSince(self))
        if elapsed < 60 {
            return "\(elapsed) seconds"
        }

        let minutes = elapsed / 60
        let seconds = elapsed % 60
        if elapsed < 3600 {
            return "\(minutes) minutes \(seconds) seconds"
        }

        let hours = elapsed / 3600
        let remainingMinutes = (elapsed % 3600) / 60
        return "\(hours) hours \(remainingMinutes) minutes"
    }
}
