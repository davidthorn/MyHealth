//
//  InsightsScene.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct InsightsScene: View {
    @StateObject private var viewModel: InsightsViewModel

    public init(service: InsightsServiceProtocol) {
        _viewModel = StateObject(wrappedValue: InsightsViewModel(service: service))
    }

    public var body: some View {
        NavigationStack(path: $viewModel.path) {
            VStack(spacing: 16) {
                Text(viewModel.title)
                    .font(.title)
                Text("Patterns and correlations")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("Insights")
            .navigationDestination(for: InsightsRoute.self) { route in
                switch route {
                case .insight(let value):
                    Text("Insight: \(value)")
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
            Label("Insights", systemImage: "sparkles")
        }
    }
}
