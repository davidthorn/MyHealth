//
//  WorkoutsView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct WorkoutsView: View {
    @StateObject private var viewModel: WorkoutsViewModel
    private let workoutListItemService: WorkoutListItemServiceProtocol

    public init(service: WorkoutsServiceProtocol, workoutListItemService: WorkoutListItemServiceProtocol) {
        _viewModel = StateObject(wrappedValue: WorkoutsViewModel(service: service))
        self.workoutListItemService = workoutListItemService
    }

    public var body: some View {
        List {
            if viewModel.workouts.isEmpty {
                ContentUnavailableView("No Workouts", systemImage: "figure.run", description: Text("Start a workout to see it here."))
            } else {
                ForEach(viewModel.workouts) { workout in
                    WorkoutListItemView(service: workoutListItemService, workout: workout)
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

#if DEBUG
#Preview {
    NavigationStack {
        WorkoutsView(
            service: AppServices.shared.workoutsService,
            workoutListItemService: AppServices.shared.workoutListItemService
        )
    }
}
#endif
