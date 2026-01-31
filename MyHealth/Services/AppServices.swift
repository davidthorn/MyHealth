//
//  AppServices.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor

@MainActor
public struct AppServices: AppServicesProviding {
    private let workoutStore: WorkoutStoreProtocol
    public let dashboardService: DashboardServiceProtocol
    public let metricsService: MetricsServiceProtocol
    public let workoutsService: WorkoutsServiceProtocol
    public let workoutFlowService: WorkoutFlowServiceProtocol
    public let workoutListItemService: WorkoutListItemServiceProtocol
    public let workoutDetailService: WorkoutDetailServiceProtocol
    public let insightsService: InsightsServiceProtocol
    public let settingsService: SettingsServiceProtocol

    public init(
        workoutStore: WorkoutStoreProtocol,
        dashboardService: DashboardServiceProtocol,
        metricsService: MetricsServiceProtocol,
        workoutsService: WorkoutsServiceProtocol,
        workoutFlowService: WorkoutFlowServiceProtocol,
        workoutListItemService: WorkoutListItemServiceProtocol,
        workoutDetailService: WorkoutDetailServiceProtocol,
        insightsService: InsightsServiceProtocol,
        settingsService: SettingsServiceProtocol
    ) {
        self.workoutStore = workoutStore
        self.dashboardService = dashboardService
        self.metricsService = metricsService
        self.workoutsService = workoutsService
        self.workoutFlowService = workoutFlowService
        self.workoutListItemService = workoutListItemService
        self.workoutDetailService = workoutDetailService
        self.insightsService = insightsService
        self.settingsService = settingsService
    }

    public static func live() -> AppServices {
        let workoutStore = WorkoutStore()
        let healthKitAdapter = HealthKitAdapter()
        let workoutSource = WorkoutStoreSource(healthKitAdapter: healthKitAdapter)
        return AppServices(
            workoutStore: workoutStore,
            dashboardService: DashboardService(),
            metricsService: MetricsService(),
            workoutsService: WorkoutsService(source: workoutSource),
            workoutFlowService: WorkoutFlowService(store: workoutStore),
            workoutListItemService: WorkoutListItemService(),
            workoutDetailService: WorkoutDetailService(store: workoutStore),
            insightsService: InsightsService(),
            settingsService: SettingsService()
        )
    }

    public static let shared = AppServices.live()

    public func loadStores() async {
        try? await workoutStore.loadAll()
    }
}
