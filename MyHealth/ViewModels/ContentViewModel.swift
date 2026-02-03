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
    public var heartRateReadingDetailService: HeartRateReadingDetailServiceProtocol {
        services.heartRateReadingDetailService
    }
    public var stepsSummaryService: StepsSummaryServiceProtocol { services.stepsSummaryService }
    public var stepsDetailService: StepsDetailServiceProtocol { services.stepsDetailService }
    public var flightsSummaryService: FlightsSummaryServiceProtocol { services.flightsSummaryService }
    public var flightsDetailService: FlightsDetailServiceProtocol { services.flightsDetailService }
    public var standHoursSummaryService: StandHoursSummaryServiceProtocol { services.standHoursSummaryService }
    public var standHoursDetailService: StandHoursDetailServiceProtocol { services.standHoursDetailService }
    public var caloriesSummaryService: CaloriesSummaryServiceProtocol { services.caloriesSummaryService }
    public var caloriesDetailService: CaloriesDetailServiceProtocol { services.caloriesDetailService }
    public var sleepSummaryService: SleepSummaryServiceProtocol { services.sleepSummaryService }
    public var sleepDetailService: SleepDetailServiceProtocol { services.sleepDetailService }
    public var sleepReadingDetailService: SleepReadingDetailServiceProtocol { services.sleepReadingDetailService }
    public var activityRingsSummaryService: ActivityRingsSummaryServiceProtocol { services.activityRingsSummaryService }
    public var activityRingsDetailService: ActivityRingsDetailServiceProtocol { services.activityRingsDetailService }
    public var activityRingsDayDetailService: ActivityRingsDayDetailServiceProtocol { services.activityRingsDayDetailService }
    public var activityRingsMetricDayDetailService: ActivityRingsMetricDayDetailServiceProtocol { services.activityRingsMetricDayDetailService }
    public var restingHeartRateSummaryService: RestingHeartRateSummaryServiceProtocol { services.restingHeartRateSummaryService }
    public var restingHeartRateHistoryService: RestingHeartRateHistoryServiceProtocol { services.restingHeartRateHistoryService }
    public var restingHeartRateDayDetailService: RestingHeartRateDayDetailServiceProtocol { services.restingHeartRateDayDetailService }
    public var workoutsService: WorkoutsServiceProtocol { services.workoutsService }
    public var workoutFlowService: WorkoutFlowServiceProtocol { services.workoutFlowService }
    public var workoutListItemService: WorkoutListItemServiceProtocol { services.workoutListItemService }
    public var workoutDetailService: WorkoutDetailServiceProtocol { services.workoutDetailService }
    public var locationService: LocationServiceProtocol { services.locationService }
    public var workoutLocationManager: WorkoutLocationManaging { services.workoutLocationManager }
    public var nutritionService: NutritionServiceProtocol { services.nutritionService }
    public var nutritionTypeListService: NutritionTypeListServiceProtocol { services.nutritionTypeListService }
    public var nutritionEntryDetailService: NutritionEntryDetailServiceProtocol { services.nutritionEntryDetailService }
    public var insightsService: InsightsServiceProtocol { services.insightsService }
    public var settingsService: SettingsServiceProtocol { services.settingsService }
}
