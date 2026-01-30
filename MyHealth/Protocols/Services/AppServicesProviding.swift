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
    var workoutsService: WorkoutsServiceProtocol { get }
    var workoutFlowService: WorkoutFlowServiceProtocol { get }
    var insightsService: InsightsServiceProtocol { get }
    var settingsService: SettingsServiceProtocol { get }
}
