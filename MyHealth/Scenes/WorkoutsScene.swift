//
//  WorkoutsScene.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct WorkoutsScene: View {
    @StateObject private var viewModel: WorkoutsViewModel

    public init(service: WorkoutsServiceProtocol) {
        _viewModel = StateObject(wrappedValue: WorkoutsViewModel(service: service))
    }

    public var body: some View {
        NavigationStack(path: $viewModel.path) {
            VStack(spacing: 16) {
                Text(viewModel.title)
                    .font(.title)
                Text("History and summaries")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("Workouts")
            .navigationDestination(for: WorkoutsRoute.self) { route in
                switch route {
                case .workout(let value):
                    Text("Workout: \(value)")
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
            Label("Workouts", systemImage: "figure.run")
        }
    }
}
