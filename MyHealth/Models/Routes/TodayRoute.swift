//
//  TodayRoute.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum TodayRoute: Hashable {
    case detail(String)
    case activityRingsSummary
    case activityRingsDay(Date)
    case activityRingsMetric(ActivityRingsMetric, Date)

    public init(detail: String) {
        self = .detail(detail)
    }
}
