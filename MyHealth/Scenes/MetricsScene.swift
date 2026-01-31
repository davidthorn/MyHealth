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
    
    public init(service: MetricsServiceProtocol) {
        self.service = service
        self._path = State(initialValue: [])
    }
    
    public var body: some View {
        NavigationStack(path: $path) {
            MetricsView(service: service)
                .navigationTitle("Metrics")
                .navigationDestination(for: MetricsRoute.self) { route in
                    switch route {
                    case .metric(let value):
                        VStack(spacing: 12) {
                            Text(value)
                                .font(.title2.weight(.bold))
                            Text("Detailed insights coming soon.")
                                .foregroundStyle(.secondary)
                        }
                        .padding()
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
    MetricsScene(service: AppServices.shared.metricsService)
}
#endif
