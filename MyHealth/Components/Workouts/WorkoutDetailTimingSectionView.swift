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
        Section("Timing") {
            LabeledContent("Start", value: workout.startedAt.formatted(date: .abbreviated, time: .shortened))
            LabeledContent("End", value: workout.endedAt.formatted(date: .abbreviated, time: .shortened))
            LabeledContent("Duration", value: durationText ?? "—")
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
    return List {
        WorkoutDetailTimingSectionView(workout: workout, durationText: "25:00")
    }
}
#endif
