//
//  AppServicesProviding.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol AppServicesProviding {
    var todayService: TodayServiceProtocol { get }
    var hydrationService: HydrationOverviewServiceProtocol { get }
    var hydrationEntryService: HydrationEntryServiceProtocol { get }
    var metricsService: MetricsServiceProtocol { get }
    var heartRateSummaryService: HeartRateSummaryServiceProtocol { get }
    var heartRateReadingDetailService: HeartRateReadingDetailServiceProtocol { get }
    var cardioFitnessDetailService: CardioFitnessDetailServiceProtocol { get }
    var bloodOxygenDetailService: BloodOxygenDetailServiceProtocol { get }
    var exerciseMinutesDetailService: ExerciseMinutesDetailServiceProtocol { get }
    var heartRateVariabilityDetailService: HeartRateVariabilityDetailServiceProtocol { get }
    var stepsSummaryService: StepsSummaryServiceProtocol { get }
    var stepsDetailService: StepsDetailServiceProtocol { get }
    var flightsSummaryService: FlightsSummaryServiceProtocol { get }
    var flightsDetailService: FlightsDetailServiceProtocol { get }
    var standHoursSummaryService: StandHoursSummaryServiceProtocol { get }
    var standHoursDetailService: StandHoursDetailServiceProtocol { get }
    var caloriesSummaryService: CaloriesSummaryServiceProtocol { get }
    var caloriesDetailService: CaloriesDetailServiceProtocol { get }
    var sleepSummaryService: SleepSummaryServiceProtocol { get }
    var sleepDetailService: SleepDetailServiceProtocol { get }
    var sleepReadingDetailService: SleepReadingDetailServiceProtocol { get }
    var activityRingsSummaryService: ActivityRingsSummaryServiceProtocol { get }
    var activityRingsDetailService: ActivityRingsDetailServiceProtocol { get }
    var activityRingsDayDetailService: ActivityRingsDayDetailServiceProtocol { get }
    var activityRingsMetricDayDetailService: ActivityRingsMetricDayDetailServiceProtocol { get }
    var restingHeartRateSummaryService: RestingHeartRateSummaryServiceProtocol { get }
    var restingHeartRateHistoryService: RestingHeartRateHistoryServiceProtocol { get }
    var restingHeartRateDayDetailService: RestingHeartRateDayDetailServiceProtocol { get }
    var workoutsService: WorkoutsServiceProtocol { get }
    var workoutFlowService: WorkoutFlowServiceProtocol { get }
    var workoutListItemService: WorkoutListItemServiceProtocol { get }
    var workoutDetailService: WorkoutDetailServiceProtocol { get }
    var locationService: LocationServiceProtocol { get }
    var workoutLocationManager: WorkoutLocationManaging { get }
    var nutritionService: NutritionServiceProtocol { get }
    var nutritionTypeListService: NutritionTypeListServiceProtocol { get }
    var nutritionEntryDetailService: NutritionEntryDetailServiceProtocol { get }
    var insightsService: InsightsServiceProtocol { get }
    var settingsService: SettingsServiceProtocol { get }

    func loadStores() async
    func requestAuthorization() async -> Bool
}
