//
//  DashboardRoute.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum DashboardRoute: Hashable {
    case detail(String)
    case activityRingsDay(Date)
    case activityRingsMetric(ActivityRingsMetric, Date)

    public init(detail: String) {
        self = .detail(detail)
    }
}
