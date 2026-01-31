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
    
    public init(
        service: MetricsServiceProtocol,
        heartRateSummaryService: HeartRateSummaryServiceProtocol,
        heartRateReadingDetailService: HeartRateReadingDetailServiceProtocol,
        stepsSummaryService: StepsSummaryServiceProtocol,
        stepsDetailService: StepsDetailServiceProtocol,
        flightsSummaryService: FlightsSummaryServiceProtocol,
        flightsDetailService: FlightsDetailServiceProtocol
    ) {
        self.service = service
        self.heartRateSummaryService = heartRateSummaryService
        self.heartRateReadingDetailService = heartRateReadingDetailService
        self.stepsSummaryService = stepsSummaryService
        self.stepsDetailService = stepsDetailService
        self.flightsSummaryService = flightsSummaryService
        self.flightsDetailService = flightsDetailService
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
                        default:
                            VStack(spacing: 12) {
                                Text(category.title)
                                    .font(.title2.weight(.bold))
                                Text("Detailed insights coming soon.")
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
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
        flightsDetailService: AppServices.shared.flightsDetailService
    )
}
#endif
