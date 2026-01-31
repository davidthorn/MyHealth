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
    public let heartRateSummaryService: HeartRateSummaryServiceProtocol
    public let heartRateReadingDetailService: HeartRateReadingDetailServiceProtocol
    public let stepsSummaryService: StepsSummaryServiceProtocol
    public let stepsDetailService: StepsDetailServiceProtocol
    public let flightsSummaryService: FlightsSummaryServiceProtocol
    public let flightsDetailService: FlightsDetailServiceProtocol
    public let standHoursSummaryService: StandHoursSummaryServiceProtocol
    public let standHoursDetailService: StandHoursDetailServiceProtocol
    public let caloriesSummaryService: CaloriesSummaryServiceProtocol
    public let caloriesDetailService: CaloriesDetailServiceProtocol
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
        heartRateSummaryService: HeartRateSummaryServiceProtocol,
        heartRateReadingDetailService: HeartRateReadingDetailServiceProtocol,
        stepsSummaryService: StepsSummaryServiceProtocol,
        stepsDetailService: StepsDetailServiceProtocol,
        flightsSummaryService: FlightsSummaryServiceProtocol,
        flightsDetailService: FlightsDetailServiceProtocol,
        standHoursSummaryService: StandHoursSummaryServiceProtocol,
        standHoursDetailService: StandHoursDetailServiceProtocol,
        caloriesSummaryService: CaloriesSummaryServiceProtocol,
        caloriesDetailService: CaloriesDetailServiceProtocol,
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
        self.heartRateSummaryService = heartRateSummaryService
        self.heartRateReadingDetailService = heartRateReadingDetailService
        self.stepsSummaryService = stepsSummaryService
        self.stepsDetailService = stepsDetailService
        self.flightsSummaryService = flightsSummaryService
        self.flightsDetailService = flightsDetailService
        self.standHoursSummaryService = standHoursSummaryService
        self.standHoursDetailService = standHoursDetailService
        self.caloriesSummaryService = caloriesSummaryService
        self.caloriesDetailService = caloriesDetailService
        self.workoutsService = workoutsService
        self.workoutFlowService = workoutFlowService
        self.workoutListItemService = workoutListItemService
        self.workoutDetailService = workoutDetailService
        self.insightsService = insightsService
        self.settingsService = settingsService
    }

    public static func live() -> AppServices {
        let workoutStore = WorkoutStore()
        let healthKitAdapter = HealthKitAdapter.live()
        let workoutSource = WorkoutStoreSource(healthKitAdapter: healthKitAdapter)
        return AppServices(
            workoutStore: workoutStore,
            dashboardService: DashboardService(),
            metricsService: MetricsService(),
            heartRateSummaryService: HeartRateSummaryService(healthKitAdapter: healthKitAdapter),
            heartRateReadingDetailService: HeartRateReadingDetailService(healthKitAdapter: healthKitAdapter),
            stepsSummaryService: StepsSummaryService(healthKitAdapter: healthKitAdapter),
            stepsDetailService: StepsDetailService(healthKitAdapter: healthKitAdapter),
            flightsSummaryService: FlightsSummaryService(healthKitAdapter: healthKitAdapter),
            flightsDetailService: FlightsDetailService(healthKitAdapter: healthKitAdapter),
            standHoursSummaryService: StandHoursSummaryService(healthKitAdapter: healthKitAdapter),
            standHoursDetailService: StandHoursDetailService(healthKitAdapter: healthKitAdapter),
            caloriesSummaryService: CaloriesSummaryService(healthKitAdapter: healthKitAdapter),
            caloriesDetailService: CaloriesDetailService(healthKitAdapter: healthKitAdapter),
            workoutsService: WorkoutsService(source: workoutSource),
            workoutFlowService: WorkoutFlowService(store: workoutStore),
            workoutListItemService: WorkoutListItemService(),
            workoutDetailService: WorkoutDetailService(source: workoutSource),
            insightsService: InsightsService(),
            settingsService: SettingsService()
        )
    }

    public static let shared = AppServices.live()

    public func loadStores() async {
        try? await workoutStore.loadAll()
    }
}
