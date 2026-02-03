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
    @State private var isDeleteProgressPresented: Bool = false
    @State private var shouldDeleteAfterProgress: Bool = false
    @State private var isDeleteErrorPresented: Bool = false

    public init(service: WorkoutDetailServiceProtocol, id: UUID) {
        _viewModel = StateObject(wrappedValue: WorkoutDetailViewModel(service: service, id: id))
    }

    public var body: some View {
        Group {
            if let workout = viewModel.workout {
                List {
                    WorkoutDetailSummarySectionView(workout: workout)
                    if !viewModel.canDelete {
                        Section {
                            Label("Read-only workout", systemImage: "lock.fill")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.secondary)
                        } footer: {
                            Text("This workout was created by another app and can’t be deleted here.")
                                .font(.footnote)
                        }
                    }
                    WorkoutDetailTimingSectionView(workout: workout, durationText: viewModel.durationText)
                    if !viewModel.routePoints.isEmpty {
                        WorkoutDetailRouteSectionView(
                            points: viewModel.routePoints,
                            onFullScreen: { isRouteFullScreenPresented = true }
                        )
                        WorkoutDetailSplitsSectionView(
                            splits: viewModel.splits,
                            durationText: viewModel.splitDurationText,
                            paceText: viewModel.paceText,
                            heartRateText: viewModel.heartRateText
                        )
                        WorkoutDetailHeartRateSectionView(points: viewModel.workoutHeartRatePoints)
                    }
                }
            } else {
                ContentUnavailableView("Workout Not Found", systemImage: "figure.run", description: Text("This workout is no longer available."))
            }
        }
        .navigationTitle("Workout")
        .toolbar {
            if viewModel.canDelete {
                Button(role: .destructive) {
                    viewModel.requestDelete()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
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
                viewModel.isDeleteAlertPresented = false
                shouldDeleteAfterProgress = true
                isDeleteProgressPresented = true
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
        .sheet(isPresented: $isDeleteProgressPresented) {
            VStack(spacing: 16) {
                ProgressView()
                Text("Deleting workout…")
                    .font(.headline)
            }
            .padding()
            .presentationDetents([.height(160)])
            .task {
                guard shouldDeleteAfterProgress else { return }
                shouldDeleteAfterProgress = false
                do {
                    try await viewModel.delete()
                    await MainActor.run {
                        isDeleteProgressPresented = false
                        dismiss()
                    }
                } catch {
                    await MainActor.run {
                        viewModel.errorMessage = error.localizedDescription
                        isDeleteProgressPresented = false
                        isDeleteErrorPresented = true
                    }
                }
            }
        }
        .alert("Unable to Delete", isPresented: $isDeleteErrorPresented) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .onChange(of: isDeleteErrorPresented) { isPresented in
            if !isPresented {
                viewModel.errorMessage = nil
            }
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
