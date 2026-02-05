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
            TodayScene(
                service: viewModel.todayService,
                activityRingsSummaryService: viewModel.activityRingsSummaryService,
                activityRingsDayDetailService: viewModel.activityRingsDayDetailService,
                activityRingsMetricDayDetailService: viewModel.activityRingsMetricDayDetailService,
                hydrationService: viewModel.hydrationService,
                hydrationEntryService: viewModel.hydrationEntryService,
                sleepSummaryService: viewModel.sleepSummaryService,
                sleepEntryService: viewModel.sleepEntryService,
                sleepDetailService: viewModel.sleepDetailService,
                sleepReadingDetailService: viewModel.sleepReadingDetailService
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
                sleepEntryService: viewModel.sleepEntryService,
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
            MoreScene(
                insightsService: viewModel.insightsService,
                settingsService: viewModel.settingsService
            )
        }
    }
}

#if DEBUG
#Preview {
    ContentView(services: AppServices.shared)
}
#endif
