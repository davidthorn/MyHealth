//
//  ActivityRingsRoute.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum ActivityRingsRoute: Hashable {
    case detail(Date)
    case day(Date)
    case metric(ActivityRingsMetric, Date)
    case history

    public init(detail date: Date) {
        self = .detail(date)
    }
}
