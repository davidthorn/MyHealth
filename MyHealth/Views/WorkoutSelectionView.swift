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
        List(viewModel.types) { workoutType in
            Button {
                viewModel.startWorkout(type: workoutType)
            } label: {
                Text(workoutType.displayName)
            }
        }
        .navigationTitle("Select Workout")
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
