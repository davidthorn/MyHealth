//
//  CurrentWorkoutView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct CurrentWorkoutView: View {
    @StateObject private var viewModel: CurrentWorkoutViewModel

    public init(
        service: WorkoutFlowServiceProtocol,
        locationService: LocationServiceProtocol,
        workoutLocationManager: WorkoutLocationManaging
    ) {
        _viewModel = StateObject(
            wrappedValue: CurrentWorkoutViewModel(
                service: service,
                locationService: locationService,
                workoutLocationManager: workoutLocationManager
            )
        )
    }

    private var mapPoints: [WorkoutRoutePoint] {
        if viewModel.routePoints.isEmpty {
            return viewModel.currentLocationPoint.map { [$0] } ?? []
        }
        return viewModel.routePoints
    }

    public var body: some View {
        Group {
            if let session = viewModel.currentSession {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        CurrentWorkoutHeaderView(session: session, elapsedText: viewModel.elapsedText)

                        if viewModel.isOutdoorSupported {
                            if viewModel.isLocationAuthorized {
                                WorkoutRouteMapView(points: mapPoints, height: 240)
                                if let gpsStatusText = viewModel.gpsStatusText,
                                   viewModel.currentSession?.status == .notStarted {
                                    CurrentWorkoutGpsStatusView(
                                        statusText: gpsStatusText,
                                        isLocked: viewModel.hasGoodGpsFix
                                    )
                                }
                            } else {
                                CurrentWorkoutLocationPermissionView(
                                    isDenied: viewModel.isLocationDenied,
                                    onRequest: viewModel.requestLocationAuthorization
                                )
                            }

                            CurrentWorkoutStatsView(
                                distanceText: viewModel.distanceText,
                                paceText: viewModel.paceText,
                                speedText: viewModel.speedText
                            )

                            CurrentWorkoutSplitsView(splits: viewModel.splits)
                        } else {
                            ContentUnavailableView(
                                "Outdoor Only",
                                systemImage: "location.slash",
                                description: Text("GPS workouts are supported for walking, running, and cycling.")
                            )
                        }

                        CurrentWorkoutControlsView(
                            status: session.status,
                            canStart: viewModel.canStartWorkout,
                            onStart: viewModel.beginWorkout,
                            onPause: viewModel.pauseWorkout,
                            onResume: viewModel.resumeWorkout,
                            onEnd: {
                                Task {
                                    await viewModel.endWorkout()
                                }
                            }
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
            } else {
                ContentUnavailableView(
                    "No Active Workout",
                    systemImage: "figure.run",
                    description: Text("Start a workout to begin tracking.")
                )
            }
        }
        .navigationTitle("Current Workout")
        .task {
            await viewModel.start()
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
        CurrentWorkoutView(
            service: AppServices.shared.workoutFlowService,
            locationService: AppServices.shared.locationService,
            workoutLocationManager: AppServices.shared.workoutLocationManager
        )
    }
}
#endif
