//
//  WorkoutDetailSummarySectionView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct WorkoutDetailSummarySectionView: View {
    private let workout: Workout
    private let durationText: String?

    public init(workout: Workout, durationText: String?) {
        self.workout = workout
        self.durationText = durationText
    }

    public var body: some View {
        let accent = workout.type.accentColor

        WorkoutDetailCardView(accentColor: accent) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(accent.opacity(0.18))
                            .frame(width: 48, height: 48)
                        Image(systemName: workout.type.iconName)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(accent)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(workout.title)
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(.primary)
                        Text(workout.type.displayName)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(dateRangeText)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }

                HStack(spacing: 12) {
                    WorkoutDetailStatTileView(
                        title: "Distance",
                        value: distanceText,
                        systemImage: "map",
                        tint: accent
                    )
                    WorkoutDetailStatTileView(
                        title: "Duration",
                        value: durationText ?? "—",
                        systemImage: "timer",
                        tint: accent
                    )
                    WorkoutDetailStatTileView(
                        title: "Energy",
                        value: energyText,
                        systemImage: "flame",
                        tint: accent
                    )
                }
            }
        }
    }
}

private extension WorkoutDetailSummarySectionView {
    var dateRangeText: String {
        let dateText = workout.startedAt.formatted(date: .abbreviated, time: .omitted)
        let startTime = workout.startedAt.formatted(date: .omitted, time: .shortened)
        let endTime = workout.endedAt.formatted(date: .omitted, time: .shortened)
        return "\(dateText) | \(startTime) - \(endTime)"
    }

    var distanceText: String {
        guard let meters = workout.totalDistanceMeters else { return "—" }
        let kilometers = meters / 1000
        return "\(kilometers.formatted(.number.precision(.fractionLength(2)))) km"
    }

    var energyText: String {
        guard let energy = workout.totalEnergyBurnedKilocalories else { return "—" }
        return "\(energy.formatted(.number.precision(.fractionLength(0)))) kcal"
    }
}

#if DEBUG
#Preview {
    ScrollView {
        WorkoutDetailSummarySectionView(
            workout: Workout(
                id: UUID(),
                title: "Morning Run",
                type: .running,
                startedAt: Date().addingTimeInterval(-1800),
                endedAt: Date()
            ),
            durationText: "30:00"
        )
        .padding()
    }
}
#endif
