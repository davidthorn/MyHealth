//
//  TodayScene.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct TodayScene: View {
    @State private var path: NavigationPath
    private let service: TodayServiceProtocol
    private let activityRingsSummaryService: ActivityRingsSummaryServiceProtocol
    private let activityRingsDayDetailService: ActivityRingsDayDetailServiceProtocol
    private let activityRingsMetricDayDetailService: ActivityRingsMetricDayDetailServiceProtocol

    public init(
        service: TodayServiceProtocol,
        activityRingsSummaryService: ActivityRingsSummaryServiceProtocol,
        activityRingsDayDetailService: ActivityRingsDayDetailServiceProtocol,
        activityRingsMetricDayDetailService: ActivityRingsMetricDayDetailServiceProtocol
    ) {
        self.service = service
        self.activityRingsSummaryService = activityRingsSummaryService
        self.activityRingsDayDetailService = activityRingsDayDetailService
        self.activityRingsMetricDayDetailService = activityRingsMetricDayDetailService
        self._path = State(initialValue: NavigationPath())
    }

    public var body: some View {
        NavigationStack(path: $path) {
            TodayView(service: service)
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: TodayRoute.self) { route in
                switch route {
                case .detail(let value):
                    Text("Today detail: \(value)")
                case .activityRingsSummary:
                    ActivityRingsSummaryView(service: activityRingsSummaryService)
                case .activityRingsDay(let date):
                    ActivityRingsDayDetailView(service: activityRingsDayDetailService, date: date)
                case .activityRingsMetric(let metric, let date):
                    ActivityRingsMetricDayDetailView(
                        service: activityRingsMetricDayDetailService,
                        metric: metric,
                        date: date
                    )
                }
            }
        }
        .tabItem {
            Label("Today", systemImage: "house")
        }
    }
}
