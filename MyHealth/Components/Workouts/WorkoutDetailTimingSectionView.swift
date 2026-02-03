//
//  WorkoutDetailTimingSectionView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct WorkoutDetailTimingSectionView: View {
    private let workout: Workout
    private let durationText: String?

    public init(workout: Workout, durationText: String?) {
        self.workout = workout
        self.durationText = durationText
    }

    public var body: some View {
        WorkoutDetailCardView(title: "Timing") {
            VStack(spacing: 10) {
                WorkoutDetailKeyValueRowView(
                    title: "Start",
                    value: workout.startedAt.formatted(date: .abbreviated, time: .shortened)
                )
                WorkoutDetailKeyValueRowView(
                    title: "End",
                    value: workout.endedAt.formatted(date: .abbreviated, time: .shortened)
                )
                WorkoutDetailKeyValueRowView(
                    title: "Duration",
                    value: durationText ?? "—"
                )
            }
        }
    }
}

#if DEBUG
#Preview {
    let workout = Workout(
        id: UUID(),
        title: "Evening Walk",
        type: .walking,
        startedAt: Date().addingTimeInterval(-1500),
        endedAt: Date()
    )
    return ScrollView {
        WorkoutDetailTimingSectionView(workout: workout, durationText: "25:00")
            .padding()
    }
}
#endif
