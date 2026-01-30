//
//  CurrentWorkoutView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct CurrentWorkoutView: View {
    @StateObject private var viewModel: CurrentWorkoutViewModel

    public init(service: WorkoutFlowServiceProtocol) {
        _viewModel = StateObject(wrappedValue: CurrentWorkoutViewModel(service: service))
    }

    public var body: some View {
        VStack(spacing: 16) {
            if let session = viewModel.currentSession {
                Text("Current Workout")
                    .font(.title)
                Text(session.type.displayName)
                    .font(.headline)
                Text("Started at \(session.startedAt.formatted(date: .abbreviated, time: .shortened))")
                    .foregroundStyle(.secondary)
                if let elapsedText = viewModel.elapsedText {
                    Text(elapsedText)
                        .font(.headline)
                }
                Button(role: .destructive) {
                    Task {
                        await viewModel.endWorkout()
                    }
                } label: {
                    Text("End Workout")
                }
            } else {
                ContentUnavailableView("No Active Workout", systemImage: "figure.run", description: Text("Start a workout to begin tracking."))
            }
        }
        .padding()
        .navigationTitle("Current Workout")
        .task {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
        .alert("Save Failed", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    viewModel.clearError()
                }
            }
        )) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.errorMessage ?? "Unable to save workout.")
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        CurrentWorkoutView(service: AppServices.shared.workoutFlowService)
    }
}
#endif
