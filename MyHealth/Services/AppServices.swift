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
    private let healthKitAdapter: HealthKitAdapterProtocol
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
    public let sleepSummaryService: SleepSummaryServiceProtocol
    public let sleepDetailService: SleepDetailServiceProtocol
    public let sleepReadingDetailService: SleepReadingDetailServiceProtocol
    public let activityRingsSummaryService: ActivityRingsSummaryServiceProtocol
    public let activityRingsDetailService: ActivityRingsDetailServiceProtocol
    public let activityRingsDayDetailService: ActivityRingsDayDetailServiceProtocol
    public let activityRingsMetricDayDetailService: ActivityRingsMetricDayDetailServiceProtocol
    public let restingHeartRateSummaryService: RestingHeartRateSummaryServiceProtocol
    public let restingHeartRateHistoryService: RestingHeartRateHistoryServiceProtocol
    public let restingHeartRateDayDetailService: RestingHeartRateDayDetailServiceProtocol
    public let workoutsService: WorkoutsServiceProtocol
    public let workoutFlowService: WorkoutFlowServiceProtocol
    public let workoutListItemService: WorkoutListItemServiceProtocol
    public let workoutDetailService: WorkoutDetailServiceProtocol
    public let locationService: LocationServiceProtocol
    public let nutritionService: NutritionServiceProtocol
    public let nutritionTypeListService: NutritionTypeListServiceProtocol
    public let nutritionEntryDetailService: NutritionEntryDetailServiceProtocol
    public let insightsService: InsightsServiceProtocol
    public let settingsService: SettingsServiceProtocol

    public init(
        healthKitAdapter: HealthKitAdapterProtocol,
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
        sleepSummaryService: SleepSummaryServiceProtocol,
        sleepDetailService: SleepDetailServiceProtocol,
        sleepReadingDetailService: SleepReadingDetailServiceProtocol,
        activityRingsSummaryService: ActivityRingsSummaryServiceProtocol,
        activityRingsDetailService: ActivityRingsDetailServiceProtocol,
        activityRingsDayDetailService: ActivityRingsDayDetailServiceProtocol,
        activityRingsMetricDayDetailService: ActivityRingsMetricDayDetailServiceProtocol,
        restingHeartRateSummaryService: RestingHeartRateSummaryServiceProtocol,
        restingHeartRateHistoryService: RestingHeartRateHistoryServiceProtocol,
        restingHeartRateDayDetailService: RestingHeartRateDayDetailServiceProtocol,
        workoutsService: WorkoutsServiceProtocol,
        workoutFlowService: WorkoutFlowServiceProtocol,
        workoutListItemService: WorkoutListItemServiceProtocol,
        workoutDetailService: WorkoutDetailServiceProtocol,
        locationService: LocationServiceProtocol,
        nutritionService: NutritionServiceProtocol,
        nutritionTypeListService: NutritionTypeListServiceProtocol,
        nutritionEntryDetailService: NutritionEntryDetailServiceProtocol,
        insightsService: InsightsServiceProtocol,
        settingsService: SettingsServiceProtocol
    ) {
        self.healthKitAdapter = healthKitAdapter
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
        self.sleepSummaryService = sleepSummaryService
        self.sleepDetailService = sleepDetailService
        self.sleepReadingDetailService = sleepReadingDetailService
        self.activityRingsSummaryService = activityRingsSummaryService
        self.activityRingsDetailService = activityRingsDetailService
        self.activityRingsDayDetailService = activityRingsDayDetailService
        self.activityRingsMetricDayDetailService = activityRingsMetricDayDetailService
        self.restingHeartRateSummaryService = restingHeartRateSummaryService
        self.restingHeartRateHistoryService = restingHeartRateHistoryService
        self.restingHeartRateDayDetailService = restingHeartRateDayDetailService
        self.workoutsService = workoutsService
        self.workoutFlowService = workoutFlowService
        self.workoutListItemService = workoutListItemService
        self.workoutDetailService = workoutDetailService
        self.locationService = locationService
        self.nutritionService = nutritionService
        self.nutritionTypeListService = nutritionTypeListService
        self.nutritionEntryDetailService = nutritionEntryDetailService
        self.insightsService = insightsService
        self.settingsService = settingsService
    }

    public static func live() -> AppServices {
        let workoutStore = WorkoutStore()
        let healthKitAdapter = HealthKitAdapter.live()
        let workoutSource = WorkoutStoreSource(healthKitAdapter: healthKitAdapter)
        let heartRateSource = HeartRateStoreSource(healthKitAdapter: healthKitAdapter)
        return AppServices(
            healthKitAdapter: healthKitAdapter,
            workoutStore: workoutStore,
            dashboardService: DashboardService(healthKitAdapter: healthKitAdapter),
            metricsService: MetricsService(healthKitAdapter: healthKitAdapter),
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
            sleepSummaryService: SleepSummaryService(healthKitAdapter: healthKitAdapter),
            sleepDetailService: SleepDetailService(healthKitAdapter: healthKitAdapter),
            sleepReadingDetailService: SleepReadingDetailService(healthKitAdapter: healthKitAdapter),
            activityRingsSummaryService: ActivityRingsSummaryService(healthKitAdapter: healthKitAdapter),
            activityRingsDetailService: ActivityRingsDetailService(healthKitAdapter: healthKitAdapter),
            activityRingsDayDetailService: ActivityRingsDayDetailService(healthKitAdapter: healthKitAdapter),
            activityRingsMetricDayDetailService: ActivityRingsMetricDayDetailService(healthKitAdapter: healthKitAdapter),
            restingHeartRateSummaryService: RestingHeartRateSummaryService(healthKitAdapter: healthKitAdapter),
            restingHeartRateHistoryService: RestingHeartRateHistoryService(healthKitAdapter: healthKitAdapter),
            restingHeartRateDayDetailService: RestingHeartRateDayDetailService(healthKitAdapter: healthKitAdapter),
            workoutsService: WorkoutsService(source: workoutSource),
            workoutFlowService: WorkoutFlowService(store: workoutStore),
            workoutListItemService: WorkoutListItemService(workoutSource: workoutSource, heartRateSource: heartRateSource),
            workoutDetailService: WorkoutDetailService(source: workoutSource, heartRateSource: heartRateSource),
            locationService: MockLocationService(),
            nutritionService: NutritionService(healthKitAdapter: healthKitAdapter),
            nutritionTypeListService: NutritionTypeListService(healthKitAdapter: healthKitAdapter),
            nutritionEntryDetailService: NutritionEntryDetailService(healthKitAdapter: healthKitAdapter),
            insightsService: InsightsService(),
            settingsService: SettingsService()
        )
    }

    public static let shared = AppServices.live()

    public func loadStores() async {
        try? await workoutStore.loadAll()
    }

    public func requestAuthorization() async -> Bool {
        await healthKitAdapter.authorizationProvider.requestAllAuthorization()
    }
}
