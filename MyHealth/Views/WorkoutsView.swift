//
//  WorkoutsView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct WorkoutsView: View {
    @StateObject private var viewModel: WorkoutsViewModel

    public init(service: WorkoutsServiceProtocol) {
        _viewModel = StateObject(wrappedValue: WorkoutsViewModel(service: service))
    }

    public var body: some View {
        List {
            if viewModel.workouts.isEmpty {
                ContentUnavailableView("No Workouts", systemImage: "figure.run", description: Text("Start a workout to see it here."))
            } else {
                ForEach(viewModel.workouts) { workout in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(workout.title)
                            .font(.headline)
                        Text(workout.type.displayName)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle(viewModel.title)
        .task {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
    }
}

#Preview {
    NavigationStack {
        WorkoutsView(service: WorkoutsService())
    }
}
