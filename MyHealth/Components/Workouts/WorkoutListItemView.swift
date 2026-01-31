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
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .center, spacing: 8) {
                        Circle()
                            .fill(viewModel.accentColor)
                            .frame(width: 10, height: 10)
                        Text(viewModel.title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                    Text(viewModel.typeName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    if !viewModel.timeRange.isEmpty {
                        Text(viewModel.timeRange)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                Spacer(minLength: 0)
                if viewModel.isOutdoor {
                    WorkoutRouteMapView(points: viewModel.routePoints, height: 120)
                        .frame(width: 140)
                } else {
                    WorkoutListItemPlaceholderView(color: viewModel.accentColor)
                        .frame(width: 140, height: 120)
                }
            }

            HStack(spacing: 12) {
                WorkoutMetricChipView(title: "Distance", value: viewModel.distanceText, accent: viewModel.accentColor)
                    .frame(maxWidth: .infinity)
                WorkoutMetricChipView(title: "Duration", value: viewModel.durationText, accent: viewModel.accentColor)
                    .frame(maxWidth: .infinity)
            }

            HStack(spacing: 12) {
                WorkoutMetricChipView(title: "Pace", value: viewModel.paceText, accent: viewModel.accentColor)
                    .frame(maxWidth: .infinity)
                WorkoutMetricChipView(title: "Avg HR", value: viewModel.averageHeartRateText, accent: viewModel.accentColor)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(viewModel.accentColor.opacity(0.25), lineWidth: 1)
        )
        .task {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
    }
}

private struct WorkoutMetricChipView: View {
    let title: String
    let value: String
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(UIColor.tertiarySystemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(accent.opacity(0.2), lineWidth: 1)
        )
    }
}

private struct WorkoutListItemPlaceholderView: View {
    let color: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(color.opacity(0.15))
            VStack(spacing: 6) {
                Image(systemName: "figure.indoor.cycle")
                    .font(.title2)
                    .foregroundStyle(color)
                Text("Indoor")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#if DEBUG
#Preview {
    WorkoutListItemView(
        service: AppServices.shared.workoutListItemService,
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
