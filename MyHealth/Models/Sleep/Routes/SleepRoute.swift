//
//  SleepRoute.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum SleepRoute: Hashable {
    case detail
    case reading(Date)

    public init(detail: Void = ()) {
        self = .detail
    }
}
