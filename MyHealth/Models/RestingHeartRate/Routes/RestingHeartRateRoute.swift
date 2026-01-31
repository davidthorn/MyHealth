//
//  RestingHeartRateRoute.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum RestingHeartRateRoute: Hashable {
    case history
    case day(Date)

    public init(history: Void = ()) {
        self = .history
    }
}
