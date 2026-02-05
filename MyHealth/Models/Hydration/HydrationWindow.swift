//
//  HydrationWindow.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum HydrationWindow: String, CaseIterable, Codable, Hashable, Identifiable, Sendable {
    case day
    case week
    case month
    case sixMonths
    case year

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .day: return "D"
        case .week: return "W"
        case .month: return "M"
        case .sixMonths: return "6M"
        case .year: return "Y"
        }
    }

    public var days: Int {
        switch self {
        case .day: return 1
        case .week: return 7
        case .month: return 30
        case .sixMonths: return 180
        case .year: return 365
        }
    }

    public func dateRange(endingAt endDate: Date, calendar: Calendar = .current) -> (start: Date, end: Date) {
        let end = endDate
        let endStartOfDay = calendar.startOfDay(for: end)
        let offset = -(days - 1)
        let start = calendar.date(byAdding: .day, value: offset, to: endStartOfDay) ?? endStartOfDay
        return (start, end)
    }

    public init() {
        self = .day
    }
}
