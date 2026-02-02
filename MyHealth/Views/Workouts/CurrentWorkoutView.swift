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

    public init(service: WorkoutFlowServiceProtocol, locationService: LocationServiceProtocol) {
        _viewModel = StateObject(wrappedValue: CurrentWorkoutViewModel(service: service, locationService: locationService))
    }

    public var body: some View {
        Group {
            if let session = viewModel.currentSession {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Current Workout")
                                .font(.title2.weight(.bold))
                            Text(session.type.displayName)
                                .font(.headline)
                            if let startedAt = session.startedAt {
                                Text("Started at \(startedAt.formatted(date: .abbreviated, time: .shortened))")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("Ready to start")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                            if let elapsedText = viewModel.elapsedText {
                                Text(elapsedText)
                                    .font(.headline)
                            }
                        }

                        if viewModel.isOutdoorSupported {
                            let mapPoints = viewModel.routePoints.isEmpty
                                ? (viewModel.currentLocationPoint.map { [$0] } ?? [])
                                : viewModel.routePoints
                            WorkoutRouteMapView(points: mapPoints, height: 240)

                            CurrentWorkoutStatsView(
                                distanceText: viewModel.distanceText,
                                paceText: viewModel.paceText,
                                speedText: viewModel.speedText
                            )

                            VStack(alignment: .leading, spacing: 12) {
                                Text("Splits")
                                    .font(.headline)
                                WorkoutSplitsHeaderView()
                                ForEach(viewModel.splits, id: \.id) { split in
                                    WorkoutSplitRowView(
                                        index: split.index,
                                        durationText: split.formattedDurationText,
                                        paceText: split.formattedPaceText,
                                        heartRateText: split.formattedHeartRateText
                                    )
                                }
                            }
                        } else {
                            ContentUnavailableView(
                                "Outdoor Only",
                                systemImage: "location.slash",
                                description: Text("GPS workouts are supported for walking, running, and cycling.")
                            )
                        }

                        HStack(spacing: 12) {
                            switch session.status {
                            case .notStarted:
                                Button {
                                    viewModel.beginWorkout()
                                } label: {
                                    Text("Start")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                            case .paused:
                                Button {
                                    viewModel.resumeWorkout()
                                } label: {
                                    Text("Resume")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                            case .active:
                                Button {
                                    viewModel.pauseWorkout()
                                } label: {
                                    Text("Pause")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                            default:
                                fatalError("Not supported")
                            }

                            Button(role: .destructive) {
                                Task {
                                    await viewModel.endWorkout()
                                }
                            } label: {
                                Text("End")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                        }
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
            locationService: AppServices.shared.locationService
        )
    }
}
#endif
