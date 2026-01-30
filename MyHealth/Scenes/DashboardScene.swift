//
//  DashboardScene.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct DashboardScene: View {
    @StateObject private var viewModel: DashboardViewModel

    public init(service: DashboardServiceProtocol) {
        _viewModel = StateObject(wrappedValue: DashboardViewModel(service: service))
    }

    public var body: some View {
        NavigationStack(path: $viewModel.path) {
            VStack(spacing: 16) {
                Text(viewModel.title)
                    .font(.title)
                Text("Overview of your day")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("Dashboard")
            .navigationDestination(for: DashboardRoute.self) { route in
                switch route {
                case .detail(let value):
                    Text("Dashboard detail: \(value)")
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
            Label("Dashboard", systemImage: "house")
        }
    }
}
