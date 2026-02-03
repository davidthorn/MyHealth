//
//  WorkoutSelectionView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct WorkoutSelectionView: View {
    @StateObject private var viewModel: WorkoutSelectionViewModel

    public init(service: WorkoutFlowServiceProtocol) {
        _viewModel = StateObject(wrappedValue: WorkoutSelectionViewModel(service: service))
    }

    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.types) { workoutType in
                    WorkoutSelectionRowView(type: workoutType) {
                        viewModel.startWorkout(type: workoutType)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .navigationTitle("Select Workout")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        WorkoutSelectionView(service: AppServices.shared.workoutFlowService)
    }
}
#endif
