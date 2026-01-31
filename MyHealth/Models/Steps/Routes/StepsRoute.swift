//
//  StepsRoute.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum StepsRoute: Hashable {
    case detail

    public init(detail: Void = ()) {
        self = .detail
    }
}
