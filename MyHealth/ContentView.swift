//
//  ContentView.swift
//  MyHealth
//
//  Created by David Thorn on 30.01.26.
//

import SwiftUI

public struct ContentView: View {
    @StateObject private var viewModel: ContentViewModel

    public init(services: AppServicesProviding) {
        _viewModel = StateObject(wrappedValue: ContentViewModel(services: services))
    }

    public var body: some View {
        TabView {
            DashboardScene(
                service: viewModel.dashboardService,
                activityRingsDayDetailService: viewModel.activityRingsDayDetailService,
                activityRingsMetricDayDetailService: viewModel.activityRingsMetricDayDetailService
            )
            MetricsScene(
                service: viewModel.metricsService,
                heartRateSummaryService: viewModel.heartRateSummaryService,
                heartRateReadingDetailService: viewModel.heartRateReadingDetailService,
                cardioFitnessDetailService: viewModel.cardioFitnessDetailService,
                bloodOxygenDetailService: viewModel.bloodOxygenDetailService,
                exerciseMinutesDetailService: viewModel.exerciseMinutesDetailService,
                heartRateVariabilityDetailService: viewModel.heartRateVariabilityDetailService,
                stepsSummaryService: viewModel.stepsSummaryService,
                stepsDetailService: viewModel.stepsDetailService,
                flightsSummaryService: viewModel.flightsSummaryService,
                flightsDetailService: viewModel.flightsDetailService,
                standHoursSummaryService: viewModel.standHoursSummaryService,
                standHoursDetailService: viewModel.standHoursDetailService,
                caloriesSummaryService: viewModel.caloriesSummaryService,
                caloriesDetailService: viewModel.caloriesDetailService,
                sleepSummaryService: viewModel.sleepSummaryService,
                sleepDetailService: viewModel.sleepDetailService,
                sleepReadingDetailService: viewModel.sleepReadingDetailService,
                activityRingsSummaryService: viewModel.activityRingsSummaryService,
                activityRingsDetailService: viewModel.activityRingsDetailService,
                activityRingsDayDetailService: viewModel.activityRingsDayDetailService,
                activityRingsMetricDayDetailService: viewModel.activityRingsMetricDayDetailService,
                restingHeartRateSummaryService: viewModel.restingHeartRateSummaryService,
                restingHeartRateHistoryService: viewModel.restingHeartRateHistoryService,
                restingHeartRateDayDetailService: viewModel.restingHeartRateDayDetailService
            )
            NutritionScene(
                service: viewModel.nutritionService,
                nutritionTypeListService: viewModel.nutritionTypeListService,
                nutritionEntryDetailService: viewModel.nutritionEntryDetailService
            )
            WorkoutsScene(
                service: viewModel.workoutsService,
                workoutFlowService: viewModel.workoutFlowService,
                workoutListItemService: viewModel.workoutListItemService,
                workoutDetailService: viewModel.workoutDetailService,
                locationService: viewModel.locationService,
                workoutLocationManager: viewModel.workoutLocationManager
            )
            InsightsScene(service: viewModel.insightsService)
            SettingsScene(service: viewModel.settingsService)
        }
    }
}

#if DEBUG
#Preview {
    ContentView(services: AppServices.shared)
}
#endif
