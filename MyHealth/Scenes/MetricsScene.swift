//
//  MetricsScene.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct MetricsScene: View {
    @State private var path: NavigationPath
    private let service: MetricsServiceProtocol
    private let heartRateSummaryService: HeartRateSummaryServiceProtocol
    private let heartRateReadingDetailService: HeartRateReadingDetailServiceProtocol
    private let stepsSummaryService: StepsSummaryServiceProtocol
    private let stepsDetailService: StepsDetailServiceProtocol
    private let flightsSummaryService: FlightsSummaryServiceProtocol
    private let flightsDetailService: FlightsDetailServiceProtocol
    private let standHoursSummaryService: StandHoursSummaryServiceProtocol
    private let standHoursDetailService: StandHoursDetailServiceProtocol
    private let caloriesSummaryService: CaloriesSummaryServiceProtocol
    private let caloriesDetailService: CaloriesDetailServiceProtocol
    private let sleepSummaryService: SleepSummaryServiceProtocol
    private let sleepDetailService: SleepDetailServiceProtocol
    private let sleepReadingDetailService: SleepReadingDetailServiceProtocol
    private let activityRingsSummaryService: ActivityRingsSummaryServiceProtocol
    private let activityRingsDetailService: ActivityRingsDetailServiceProtocol
    private let activityRingsDayDetailService: ActivityRingsDayDetailServiceProtocol
    private let activityRingsMetricDayDetailService: ActivityRingsMetricDayDetailServiceProtocol
    
    public init(
        service: MetricsServiceProtocol,
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
        activityRingsMetricDayDetailService: ActivityRingsMetricDayDetailServiceProtocol
    ) {
        self.service = service
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
        self._path = State(initialValue: NavigationPath())
    }
    
    public var body: some View {
        NavigationStack(path: $path) {
            MetricsView(service: service)
                .navigationTitle("Metrics")
                .navigationDestination(for: MetricsRoute.self) { route in
                    switch route {
                    case .metric(let category):
                        switch category {
                        case .heartRate:
                            HeartRateSummaryView(service: heartRateSummaryService)
                        case .steps:
                            StepsSummaryView(service: stepsSummaryService)
                        case .flights:
                            FlightsSummaryView(service: flightsSummaryService)
                        case .standHours:
                            StandHoursSummaryView(service: standHoursSummaryService)
                        case .calories:
                            CaloriesSummaryView(service: caloriesSummaryService)
                        case .sleep:
                            SleepSummaryView(service: sleepSummaryService)
                        case .activityRings:
                            ActivityRingsSummaryView(service: activityRingsSummaryService)
                        }
                    }
                }
                .navigationDestination(for: HeartRateRoute.self) { route in
                    switch route {
                    case .reading(let id):
                        HeartRateReadingDetailView(
                            service: heartRateReadingDetailService,
                            id: id
                        )
                    }
                }
                .navigationDestination(for: StepsRoute.self) { route in
                    switch route {
                    case .detail:
                        StepsDetailView(service: stepsDetailService)
                    }
                }
                .navigationDestination(for: FlightsRoute.self) { route in
                    switch route {
                    case .detail:
                        FlightsDetailView(service: flightsDetailService)
                    }
                }
                .navigationDestination(for: StandHoursRoute.self) { route in
                    switch route {
                    case .detail:
                        StandHoursDetailView(service: standHoursDetailService)
                    }
                }
                .navigationDestination(for: CaloriesRoute.self) { route in
                    switch route {
                    case .detail:
                        CaloriesDetailView(service: caloriesDetailService)
                    }
                }
                .navigationDestination(for: SleepRoute.self) { route in
                    switch route {
                    case .detail:
                        SleepDetailView(service: sleepDetailService)
                    case .reading(let date):
                        SleepReadingDetailView(service: sleepReadingDetailService, date: date)
                    }
                }
                .navigationDestination(for: ActivityRingsRoute.self) { route in
                    switch route {
                    case .detail(let date):
                        ActivityRingsDayDetailView(service: activityRingsDayDetailService, date: date)
                    case .day(let date):
                        ActivityRingsDayDetailView(service: activityRingsDayDetailService, date: date)
                    case .metric(let metric, let date):
                        ActivityRingsMetricDayDetailView(
                            service: activityRingsMetricDayDetailService,
                            metric: metric,
                            date: date
                        )
                    case .history:
                        ActivityRingsListView(service: activityRingsDetailService)
                    }
                }
        }
        .tabItem {
            Label("Metrics", systemImage: "chart.bar")
        }
    }
}

#if DEBUG
#Preview("Metrics") {
    MetricsScene(
        service: AppServices.shared.metricsService,
        heartRateSummaryService: AppServices.shared.heartRateSummaryService,
        heartRateReadingDetailService: AppServices.shared.heartRateReadingDetailService,
        stepsSummaryService: AppServices.shared.stepsSummaryService,
        stepsDetailService: AppServices.shared.stepsDetailService,
        flightsSummaryService: AppServices.shared.flightsSummaryService,
        flightsDetailService: AppServices.shared.flightsDetailService,
        standHoursSummaryService: AppServices.shared.standHoursSummaryService,
        standHoursDetailService: AppServices.shared.standHoursDetailService,
        caloriesSummaryService: AppServices.shared.caloriesSummaryService,
        caloriesDetailService: AppServices.shared.caloriesDetailService,
        sleepSummaryService: AppServices.shared.sleepSummaryService,
        sleepDetailService: AppServices.shared.sleepDetailService,
        sleepReadingDetailService: AppServices.shared.sleepReadingDetailService,
        activityRingsSummaryService: AppServices.shared.activityRingsSummaryService,
        activityRingsDetailService: AppServices.shared.activityRingsDetailService,
        activityRingsDayDetailService: AppServices.shared.activityRingsDayDetailService,
        activityRingsMetricDayDetailService: AppServices.shared.activityRingsMetricDayDetailService
    )
}
#endif
