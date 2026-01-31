//
//  WorkoutDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct WorkoutDetailView: View {
    @StateObject private var viewModel: WorkoutDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isRouteFullScreenPresented: Bool = false

    public init(service: WorkoutDetailServiceProtocol, id: UUID) {
        _viewModel = StateObject(wrappedValue: WorkoutDetailViewModel(service: service, id: id))
    }

    public var body: some View {
        Group {
            if let workout = viewModel.workout {
                List {
                    Section("Summary") {
                        LabeledContent("Title", value: workout.title)
                        LabeledContent("Type", value: workout.type.displayName)
                    }
                    Section("Timing") {
                        LabeledContent("Start", value: workout.startedAt.formatted(date: .abbreviated, time: .shortened))
                        LabeledContent("End", value: workout.endedAt.formatted(date: .abbreviated, time: .shortened))
                        LabeledContent("Duration", value: viewModel.durationText ?? "—")
                    }
                    if !viewModel.routePoints.isEmpty {
                        Section {
                            WorkoutRouteMapView(points: viewModel.routePoints)
                        } header: {
                            HStack {
                                Text("Route")
                                Spacer()
                                Button("Full Screen") {
                                    isRouteFullScreenPresented = true
                                }
                                .font(.subheadline.weight(.semibold))
                            }
                        }

                        Section("Splits") {
                            if viewModel.splits.isEmpty {
                                Text("Not enough distance to compute splits.")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            } else {
                                HStack(spacing: 0) {
                                    Text("KM")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("Time")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    Text("Pace")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    Text("HR")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                .textCase(nil)
                                ForEach(viewModel.splits) { split in
                                    WorkoutSplitRowView(
                                        index: split.index,
                                        durationText: viewModel.splitDurationText(split),
                                        paceText: viewModel.paceText(split),
                                        heartRateText: viewModel.heartRateText(split)
                                    )
                                }
                            }
                        }

                        Section("Heart Rate") {
                            WorkoutHeartRateLineChartView(points: viewModel.workoutHeartRatePoints)
                        }
                    }
                }
            } else {
                ContentUnavailableView("Workout Not Found", systemImage: "figure.run", description: Text("This workout is no longer available."))
            }
        }
        .navigationTitle("Workout")
        .toolbar {
            Button(role: .destructive) {
                viewModel.requestDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .task {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
        .alert("Delete Workout?", isPresented: $viewModel.isDeleteAlertPresented) {
            Button("Delete", role: .destructive) {
                Task { [weak viewModel] in
                    guard let viewModel else { return }
                    let didDelete = await viewModel.delete()
                    guard !Task.isCancelled else { return }
                    if didDelete {
                        dismiss()
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
        .alert("Unable to Delete", isPresented: Binding(get: {
            viewModel.errorMessage != nil
        }, set: { newValue in
            if !newValue {
                viewModel.errorMessage = nil
            }
        })) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .sheet(isPresented: $isRouteFullScreenPresented) {
            WorkoutRouteFullScreenView(points: viewModel.routePoints)
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        WorkoutDetailView(service: AppServices.shared.workoutDetailService, id: UUID())
    }
}
#endif
