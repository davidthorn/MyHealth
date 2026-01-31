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
            DashboardScene(service: viewModel.dashboardService)
            MetricsScene(
                service: viewModel.metricsService,
                heartRateSummaryService: viewModel.heartRateSummaryService
            )
            WorkoutsScene(
                service: viewModel.workoutsService,
                workoutFlowService: viewModel.workoutFlowService,
                workoutListItemService: viewModel.workoutListItemService,
                workoutDetailService: viewModel.workoutDetailService
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
