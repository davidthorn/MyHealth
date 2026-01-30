//
//  WorkoutsRoute.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum WorkoutsRoute: Hashable {
    case workout(String)

    public init(workout: String) {
        self = .workout(workout)
    }
}
