//
//  FlightsRoute.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum FlightsRoute: Hashable {
    case detail

    public init(detail: Void = ()) {
        self = .detail
    }
}
