//
//  MetricsScene.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct MetricsScene: View {
    @State private var path: [MetricsRoute]
    private let service: MetricsServiceProtocol
    private let heartRateSummaryService: HeartRateSummaryServiceProtocol
    
    public init(
        service: MetricsServiceProtocol,
        heartRateSummaryService: HeartRateSummaryServiceProtocol
    ) {
        self.service = service
        self.heartRateSummaryService = heartRateSummaryService
        self._path = State(initialValue: [])
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
        heartRateSummaryService: AppServices.shared.heartRateSummaryService
    )
}
#endif
