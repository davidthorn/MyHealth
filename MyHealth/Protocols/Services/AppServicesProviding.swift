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
    var heartRateReadingDetailService: HeartRateReadingDetailServiceProtocol { get }
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
    var workoutsService: WorkoutsServiceProtocol { get }
    var workoutFlowService: WorkoutFlowServiceProtocol { get }
    var workoutListItemService: WorkoutListItemServiceProtocol { get }
    var workoutDetailService: WorkoutDetailServiceProtocol { get }
    var insightsService: InsightsServiceProtocol { get }
    var settingsService: SettingsServiceProtocol { get }

    func loadStores() async
}
