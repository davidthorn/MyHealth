//
//  AppServices.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

@MainActor
public struct AppServices: AppServicesProviding {
    public let dashboardService: DashboardServiceProtocol
    public let metricsService: MetricsServiceProtocol
    public let workoutsService: WorkoutsServiceProtocol
    public let insightsService: InsightsServiceProtocol
    public let settingsService: SettingsServiceProtocol

    public init(
        dashboardService: DashboardServiceProtocol,
        metricsService: MetricsServiceProtocol,
        workoutsService: WorkoutsServiceProtocol,
        insightsService: InsightsServiceProtocol,
        settingsService: SettingsServiceProtocol
    ) {
        self.dashboardService = dashboardService
        self.metricsService = metricsService
        self.workoutsService = workoutsService
        self.insightsService = insightsService
        self.settingsService = settingsService
    }

    public static func live() -> AppServices {
        AppServices(
            dashboardService: DashboardService(),
            metricsService: MetricsService(),
            workoutsService: WorkoutsService(),
            insightsService: InsightsService(),
            settingsService: SettingsService()
        )
    }
}
