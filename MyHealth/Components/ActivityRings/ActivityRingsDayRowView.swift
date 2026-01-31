//
//  ActivityRingsDayRowView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct ActivityRingsDayRowView: View {
    private let day: ActivityRingsDay

    public init(day: ActivityRingsDay) {
        self.day = day
    }

    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(day.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline.weight(.semibold))
                Text("Move \(Int(day.moveValue.rounded())) • Exercise \(Int(day.exerciseMinutes.rounded())) • Stand \(Int(day.standHours.rounded()))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            ActivityRingsStackView(
                moveProgress: day.moveProgress,
                exerciseProgress: day.exerciseProgress,
                standProgress: day.standProgress,
                size: 44
            )
        }
    }
}

#if DEBUG
#Preview {
    ActivityRingsDayRowView(
        day: ActivityRingsDay(
            date: Date(),
            moveValue: 520,
            moveGoal: 600,
            exerciseMinutes: 22,
            exerciseGoal: 30,
            standHours: 9,
            standGoal: 12
        )
    )
    .padding()
}
#endif
