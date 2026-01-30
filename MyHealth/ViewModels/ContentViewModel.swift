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
    public var workoutsService: WorkoutsServiceProtocol { services.workoutsService }
    public var insightsService: InsightsServiceProtocol { services.insightsService }
    public var settingsService: SettingsServiceProtocol { services.settingsService }
}
