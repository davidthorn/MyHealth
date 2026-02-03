//
//  WorkoutDetailSplitsSectionView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct WorkoutDetailSplitsSectionView: View {
    private let splits: [WorkoutSplit]
    private let durationText: (WorkoutSplit) -> String
    private let paceText: (WorkoutSplit) -> String
    private let heartRateText: (WorkoutSplit) -> String?

    public init(
        splits: [WorkoutSplit],
        durationText: @escaping (WorkoutSplit) -> String,
        paceText: @escaping (WorkoutSplit) -> String,
        heartRateText: @escaping (WorkoutSplit) -> String?
    ) {
        self.splits = splits
        self.durationText = durationText
        self.paceText = paceText
        self.heartRateText = heartRateText
    }

    public var body: some View {
        Section("Splits") {
            if splits.isEmpty {
                Text("Not enough distance to compute splits.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                WorkoutSplitsHeaderView()
                ForEach(splits) { split in
                    WorkoutSplitRowView(
                        index: split.index,
                        durationText: durationText(split),
                        paceText: paceText(split),
                        heartRateText: heartRateText(split)
                    )
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    let now = Date()
    let splits = [
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
    ]
    return List {
        WorkoutDetailSplitsSectionView(
            splits: splits,
            durationText: { $0.formattedDurationText },
            paceText: { $0.formattedPaceText },
            heartRateText: { $0.formattedHeartRateText }
        )
    }
}
#endif
