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
            MetricsScene(service: viewModel.metricsService)
            WorkoutsScene(
                service: viewModel.workoutsService,
                workoutFlowService: viewModel.workoutFlowService
            )
            InsightsScene(service: viewModel.insightsService)
            SettingsScene(service: viewModel.settingsService)
        }
    }
}

#Preview {
    ContentView(services: AppServices.live())
}
