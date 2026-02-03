//
//  CurrentWorkoutSplitsView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct CurrentWorkoutSplitsView: View {
    private let splits: [WorkoutSplit]

    public init(splits: [WorkoutSplit]) {
        self.splits = splits
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Splits")
                .font(.headline)
            WorkoutSplitsHeaderView()
            ForEach(splits, id: \.id) { split in
                WorkoutSplitRowView(
                    index: split.index,
                    durationText: split.formattedDurationText,
                    paceText: split.formattedPaceText,
                    heartRateText: split.formattedHeartRateText
                )
            }
        }
    }
}

#if DEBUG
#Preview {
    let now = Date()
    CurrentWorkoutSplitsView(splits: [
        WorkoutSplit(
            id: UUID(),
            index: 1,
            distanceMeters: 1000,
            durationSeconds: 320,
            paceSecondsPerKilometer: 320,
            startDate: now.addingTimeInterval(-700),
            endDate: now.addingTimeInterval(-380),
            averageHeartRateBpm: 148
        ),
        WorkoutSplit(
            id: UUID(),
            index: 2,
            distanceMeters: 1000,
            durationSeconds: 330,
            paceSecondsPerKilometer: 330,
            startDate: now.addingTimeInterval(-380),
            endDate: now.addingTimeInterval(-50),
            averageHeartRateBpm: 151
        )
    ])
    .padding()
}
#endif
