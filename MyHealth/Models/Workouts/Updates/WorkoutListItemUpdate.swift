//
//  WorkoutListItemUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct WorkoutListItemUpdate: Sendable {
    public let title: String
    public let typeName: String
    public let timeRange: String

    public init(title: String, typeName: String, timeRange: String) {
        self.title = title
        self.typeName = typeName
        self.timeRange = timeRange
    }
}
