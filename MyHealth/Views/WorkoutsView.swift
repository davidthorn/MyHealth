//
//  WorkoutsView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct WorkoutsView: View {
    @StateObject private var viewModel: WorkoutsViewModel
    private let workoutListItemService: WorkoutListItemServiceProtocol

    public init(service: WorkoutsServiceProtocol, workoutListItemService: WorkoutListItemServiceProtocol) {
        _viewModel = StateObject(wrappedValue: WorkoutsViewModel(service: service))
        self.workoutListItemService = workoutListItemService
    }

    public var body: some View {
        VStack(spacing: 12) {
            if viewModel.isAuthorized {
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
            } else {
                VStack(spacing: 12) {
                    ContentUnavailableView(
                        "Health Access Needed",
                        systemImage: "heart.text.square",
                        description: Text("Enable Health access to view your workouts.")
                    )
                    Button("Request Access") {
                        viewModel.requestAuthorization()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
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
