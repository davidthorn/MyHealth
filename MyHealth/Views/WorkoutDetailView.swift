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
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        WorkoutDetailView(service: WorkoutDetailService(store: WorkoutStore()), id: UUID())
    }
}
#endif
