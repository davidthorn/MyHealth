//
//  AppServicesProviding.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol AppServicesProviding {
    var dashboardService: DashboardServiceProtocol { get }
    var metricsService: MetricsServiceProtocol { get }
    var heartRateSummaryService: HeartRateSummaryServiceProtocol { get }
    var workoutsService: WorkoutsServiceProtocol { get }
    var workoutFlowService: WorkoutFlowServiceProtocol { get }
    var workoutListItemService: WorkoutListItemServiceProtocol { get }
    var workoutDetailService: WorkoutDetailServiceProtocol { get }
    var insightsService: InsightsServiceProtocol { get }
    var settingsService: SettingsServiceProtocol { get }

    func loadStores() async
}
