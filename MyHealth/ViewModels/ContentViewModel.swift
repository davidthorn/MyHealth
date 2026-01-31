//
//  ContentViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation

@MainActor
public final class ContentViewModel: ObservableObject {
    private let services: AppServicesProviding

    public init(services: AppServicesProviding) {
        self.services = services
    }

    public var dashboardService: DashboardServiceProtocol { services.dashboardService }
    public var metricsService: MetricsServiceProtocol { services.metricsService }
    public var heartRateSummaryService: HeartRateSummaryServiceProtocol { services.heartRateSummaryService }
    public var workoutsService: WorkoutsServiceProtocol { services.workoutsService }
    public var workoutFlowService: WorkoutFlowServiceProtocol { services.workoutFlowService }
    public var workoutListItemService: WorkoutListItemServiceProtocol { services.workoutListItemService }
    public var workoutDetailService: WorkoutDetailServiceProtocol { services.workoutDetailService }
    public var insightsService: InsightsServiceProtocol { services.insightsService }
    public var settingsService: SettingsServiceProtocol { services.settingsService }
}
