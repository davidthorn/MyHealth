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
        VStack(spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    WorkoutTypeFilterPillView(
                        title: "All",
                        isSelected: viewModel.selectedType == nil
                    ) {
                        viewModel.select(type: nil)
                    }
                    ForEach(viewModel.availableTypes, id: \.self) { type in
                        WorkoutTypeFilterPillView(
                            title: type.displayName,
                            isSelected: viewModel.selectedType == type
                        ) {
                            viewModel.select(type: type)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 4)
            }

            List {
                if viewModel.filteredWorkouts.isEmpty {
                    ContentUnavailableView("No Workouts", systemImage: "figure.run", description: Text("Start a workout to see it here."))
                } else {
                    ForEach(viewModel.filteredWorkouts) { workout in
                        NavigationLink(value: WorkoutsRoute.workout(workout.id)) {
                            WorkoutListItemView(service: workoutListItemService, workout: workout)
                        }
                    }
                }
            }
            .listStyle(.plain)
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
