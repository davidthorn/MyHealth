//
//  WorkoutListItemView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct WorkoutListItemView: View {
    @StateObject private var viewModel: WorkoutListItemViewModel

    public init(service: WorkoutListItemServiceProtocol, workout: Workout) {
        _viewModel = StateObject(wrappedValue: WorkoutListItemViewModel(service: service, workout: workout))
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.title)
                .font(.headline)
            Text(viewModel.typeName)
                .foregroundStyle(.secondary)
            if !viewModel.timeRange.isEmpty {
                Text(viewModel.timeRange)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
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
    WorkoutListItemView(
        service: WorkoutListItemService(),
        workout: Workout(
            id: UUID(),
            title: "Morning Run",
            type: .running,
            startedAt: Date().addingTimeInterval(-1800),
            endedAt: Date()
        )
    )
    .padding()
}
#endif
