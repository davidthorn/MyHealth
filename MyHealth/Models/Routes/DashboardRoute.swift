//
//  DashboardRoute.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum DashboardRoute: Hashable {
    case detail(String)

    public init(detail: String) {
        self = .detail(detail)
    }
}
