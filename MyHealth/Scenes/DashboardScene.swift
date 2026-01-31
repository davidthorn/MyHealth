//
//  DashboardScene.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct DashboardScene: View {
    @State private var path: NavigationPath
    private let service: DashboardServiceProtocol
    private let activityRingsDayDetailService: ActivityRingsDayDetailServiceProtocol
    private let activityRingsMetricDayDetailService: ActivityRingsMetricDayDetailServiceProtocol

    public init(
        service: DashboardServiceProtocol,
        activityRingsDayDetailService: ActivityRingsDayDetailServiceProtocol,
        activityRingsMetricDayDetailService: ActivityRingsMetricDayDetailServiceProtocol
    ) {
        self.service = service
        self.activityRingsDayDetailService = activityRingsDayDetailService
        self.activityRingsMetricDayDetailService = activityRingsMetricDayDetailService
        self._path = State(initialValue: NavigationPath())
    }

    public var body: some View {
        NavigationStack(path: $path) {
            DashboardView(
                service: service,
                onActivityRingsTap: { day in
                    path.append(DashboardRoute.activityRingsDay(day.date))
                },
                onActivityRingMetricTap: { metric, day in
                    path.append(DashboardRoute.activityRingsMetric(metric, day.date))
                }
            )
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: DashboardRoute.self) { route in
                switch route {
                case .detail(let value):
                    Text("Dashboard detail: \(value)")
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
            Label("Dashboard", systemImage: "house")
        }
    }
}
