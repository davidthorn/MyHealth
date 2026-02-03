//
//  DashboardLatestWorkoutCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct DashboardLatestWorkoutCardView: View {
    private let snapshot: DashboardLatestWorkout

    public init(snapshot: DashboardLatestWorkout) {
        self.snapshot = snapshot
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Latest Workout")
                        .font(.headline)
                    Text(snapshot.workout.title)
                        .font(.title3.weight(.semibold))
                    Text(snapshot.workout.type.displayName)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            HStack(spacing: 8) {
                WorkoutMetaPillView(label: "Start", value: snapshot.workout.startedAt.formatted(date: .omitted, time: .shortened))
                WorkoutMetaPillView(label: "End", value: snapshot.workout.endedAt.formatted(date: .omitted, time: .shortened))
                WorkoutMetaPillView(label: "Duration", value: durationText)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Route")
                    .font(.subheadline.weight(.semibold))
                WorkoutRouteMapView(points: snapshot.routePoints, height: 140)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Heart Rate")
                    .font(.subheadline.weight(.semibold))
                WorkoutHeartRateLineChartView(points: snapshot.heartRatePoints)
                    .frame(height: 140)
            }
        }
        .padding(12)
        .background(Color.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var durationText: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: snapshot.workout.startedAt, to: snapshot.workout.endedAt) ?? "—"
    }
}

private struct WorkoutMetaPillView: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.footnote.weight(.semibold))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.secondary.opacity(0.12), in: Capsule())
    }
}

#if DEBUG
#Preview {
    DashboardLatestWorkoutCardView(
        snapshot: DashboardLatestWorkout(
            workout: Workout(
                id: UUID(),
                title: "Outdoor Walk",
                type: .walking,
                startedAt: Date().addingTimeInterval(-3600),
                endedAt: Date()
            ),
            routePoints: [
                WorkoutRoutePoint(latitude: 37.332, longitude: -122.031, timestamp: Date().addingTimeInterval(-3600), horizontalAccuracy: nil),
                WorkoutRoutePoint(latitude: 37.333, longitude: -122.029, timestamp: Date().addingTimeInterval(-3300), horizontalAccuracy: nil),
                WorkoutRoutePoint(latitude: 37.334, longitude: -122.028, timestamp: Date().addingTimeInterval(-3000), horizontalAccuracy: nil)
            ],
            heartRatePoints: [
                HeartRateRangePoint(date: Date().addingTimeInterval(-3300), bpm: 98),
                HeartRateRangePoint(date: Date().addingTimeInterval(-3000), bpm: 112),
                HeartRateRangePoint(date: Date().addingTimeInterval(-2700), bpm: 120),
                HeartRateRangePoint(date: Date().addingTimeInterval(-2400), bpm: 115)
            ]
        )
    )
    .padding()
}
#endif
