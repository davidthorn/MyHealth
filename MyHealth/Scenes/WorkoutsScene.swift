//
//  WorkoutsScene.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct WorkoutsScene: View {
    @StateObject private var viewModel: WorkoutsSceneViewModel

    private let workoutsService: WorkoutsServiceProtocol
    private let workoutFlowService: WorkoutFlowServiceProtocol
    private let workoutListItemService: WorkoutListItemServiceProtocol
    private let workoutDetailService: WorkoutDetailServiceProtocol
    private let locationService: LocationServiceProtocol
    private let workoutLocationManager: WorkoutLocationManaging

    public init(
        service: WorkoutsServiceProtocol,
        workoutFlowService: WorkoutFlowServiceProtocol,
        workoutListItemService: WorkoutListItemServiceProtocol,
        workoutDetailService: WorkoutDetailServiceProtocol,
        locationService: LocationServiceProtocol,
        workoutLocationManager: WorkoutLocationManaging
    ) {
        _viewModel = StateObject(wrappedValue: WorkoutsSceneViewModel(service: workoutFlowService))
        self.workoutsService = service
        self.workoutFlowService = workoutFlowService
        self.workoutListItemService = workoutListItemService
        self.workoutDetailService = workoutDetailService
        self.locationService = locationService
        self.workoutLocationManager = workoutLocationManager
    }

    public var body: some View {
        NavigationStack(path: $viewModel.path) {
            Group {
                if viewModel.currentSession == nil {
                    WorkoutsView(service: workoutsService, workoutListItemService: workoutListItemService)
                } else {
                    CurrentWorkoutView(
                        service: workoutFlowService,
                        locationService: locationService,
                        workoutLocationManager: workoutLocationManager
                    )
                }
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.path.append(.newWorkout)
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Start new workout")
                }
            }
            .navigationDestination(for: WorkoutsRoute.self) { route in
                switch route {
                case .workout(let value):
                    WorkoutDetailView(service: workoutDetailService, id: value)
                case .newWorkout:
                    WorkoutSelectionView(service: workoutFlowService)
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
