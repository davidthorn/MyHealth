//
//  CaloriesRoute.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum CaloriesRoute: Hashable {
    case detail

    public init(detail: Void = ()) {
        self = .detail
    }
}
