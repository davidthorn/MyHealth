//
//  MetricsScene.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct MetricsScene: View {
    @StateObject private var viewModel: MetricsViewModel

    public init(service: MetricsServiceProtocol) {
        _viewModel = StateObject(wrappedValue: MetricsViewModel(service: service))
    }

    public var body: some View {
        NavigationStack(path: $viewModel.path) {
            VStack(spacing: 16) {
                Text(viewModel.title)
                    .font(.title)
                Text("Explore your metrics")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("Metrics")
            .navigationDestination(for: MetricsRoute.self) { route in
                switch route {
                case .metric(let value):
                    Text("Metric: \(value)")
                }
            }
        }
        .task {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
        .tabItem {
            Label("Metrics", systemImage: "chart.bar")
        }
    }
}
