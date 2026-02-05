//
//  TodayLatestWorkoutCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct TodayLatestWorkoutCardView: View {
    private let snapshot: TodayLatestWorkout

    public init(snapshot: TodayLatestWorkout) {
        self.snapshot = snapshot
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: workoutIconName)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 30, height: 30)
                    .background(workoutTint, in: Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text("Latest \(snapshot.workout.type.displayName) Workout")
                        .font(.headline.weight(.semibold))
                    Text(snapshot.workout.startedAt.formatted(date: .abbreviated, time: .omitted))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            HStack(spacing: 8) {
                WorkoutMetaPillView(
                    label: "Start",
                    value: snapshot.workout.startedAt.formatted(date: .omitted, time: .shortened),
                    icon: "play.fill",
                    tint: .green
                )
                .frame(maxWidth: .infinity)
                WorkoutMetaPillView(
                    label: "End",
                    value: snapshot.workout.endedAt.formatted(date: .omitted, time: .shortened),
                    icon: "stop.fill",
                    tint: .orange
                )
                .frame(maxWidth: .infinity)
                WorkoutMetaPillView(
                    label: "Duration",
                    value: durationText,
                    icon: "clock.fill",
                    tint: .blue
                )
                .frame(maxWidth: .infinity)
            }

            sectionHeader(title: "Route", icon: "map.fill", tint: .teal)
            WorkoutRouteMapView(points: snapshot.routePoints, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            sectionHeader(title: "Heart Rate", icon: "heart.fill", tint: .pink)
            HStack(spacing: 8) {
                HeartRateStatPillView(label: "Avg", value: averageHeartRateText, icon: "heart.fill", tint: .pink)
                    .frame(maxWidth: .infinity)
                HeartRateStatPillView(label: "High", value: maxHeartRateText, icon: "arrow.up.right", tint: .red)
                    .frame(maxWidth: .infinity)
                HeartRateStatPillView(label: "Low", value: minHeartRateText, icon: "arrow.down.right", tint: .blue)
                    .frame(maxWidth: .infinity)
            }
            WorkoutHeartRateLineChartView(points: snapshot.heartRatePoints)
                .frame(height: 150)
                .padding(10)
                .background(Color(UIColor.systemBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    @ViewBuilder
    private func sectionHeader(title: String, icon: String, tint: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: 22, height: 22)
                .background(tint.opacity(0.15), in: Circle())
            Text(title)
                .font(.subheadline.weight(.semibold))
            Spacer()
        }
        .padding(.top, 4)
    }

    private var workoutIconName: String {
        switch snapshot.workout.type {
        case .running:
            return "figure.run"
        case .walking:
            return "figure.walk"
        case .cycling:
            return "bicycle"
        case .swimming:
            return "figure.pool.swim"
        case .strength:
            return "dumbbell.fill"
        case .yoga:
            return "figure.cooldown"
        case .other:
            return "figure.mixed.cardio"
        }
    }

    private var workoutTint: Color {
        switch snapshot.workout.type {
        case .running:
            return .pink
        case .walking:
            return .green
        case .cycling:
            return .blue
        case .swimming:
            return .teal
        case .strength:
            return .orange
        case .yoga:
            return .purple
        case .other:
            return .gray
        }
    }

    private var durationText: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: snapshot.workout.startedAt, to: snapshot.workout.endedAt) ?? "—"
    }

    private var averageHeartRateText: String {
        guard !snapshot.heartRatePoints.isEmpty else { return "—" }
        let total = snapshot.heartRatePoints.map(\.bpm).reduce(0, +)
        let avg = total / Double(snapshot.heartRatePoints.count)
        return "\(Int(avg.rounded())) bpm"
    }

    private var maxHeartRateText: String {
        guard let maxValue = snapshot.heartRatePoints.map(\.bpm).max() else { return "—" }
        return "\(Int(maxValue.rounded())) bpm"
    }

    private var minHeartRateText: String {
        guard let minValue = snapshot.heartRatePoints.map(\.bpm).min() else { return "—" }
        return "\(Int(minValue.rounded())) bpm"
    }
}

private struct WorkoutMetaPillView: View {
    let label: String
    let value: String
    let icon: String
    let tint: Color

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(tint)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.footnote.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(tint.opacity(0.12), in: Capsule())
    }
}

private struct HeartRateStatPillView: View {
    let label: String
    let value: String
    let icon: String
    let tint: Color

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(tint)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.footnote.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .monospacedDigit()
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(tint.opacity(0.12), in: Capsule())
    }
}

#if DEBUG
#Preview {
    TodayLatestWorkoutCardView(
        snapshot: TodayLatestWorkout(
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
