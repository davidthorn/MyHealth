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

    public init(workout: Workout) {
        self.workout = workout
    }

    public var body: some View {
        Section("Summary") {
            LabeledContent("Title", value: workout.title)
            LabeledContent("Type", value: workout.type.displayName)
        }
    }
}

#if DEBUG
#Preview {
    List {
        WorkoutDetailSummarySectionView(
            workout: Workout(
                id: UUID(),
                title: "Morning Run",
                type: .running,
                startedAt: Date().addingTimeInterval(-1800),
                endedAt: Date()
            )
        )
    }
}
#endif
