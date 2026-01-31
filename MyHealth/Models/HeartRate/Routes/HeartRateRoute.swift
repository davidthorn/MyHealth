//
//  HeartRateRoute.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum HeartRateRoute: Hashable {
    case reading(UUID)

    public init(readingId: UUID) {
        self = .reading(readingId)
    }
}
