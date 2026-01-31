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
    
    public init(
        service: MetricsServiceProtocol,
        heartRateSummaryService: HeartRateSummaryServiceProtocol,
        heartRateReadingDetailService: HeartRateReadingDetailServiceProtocol
    ) {
        self.service = service
        self.heartRateSummaryService = heartRateSummaryService
        self.heartRateReadingDetailService = heartRateReadingDetailService
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
        heartRateReadingDetailService: AppServices.shared.heartRateReadingDetailService
    )
}
#endif
