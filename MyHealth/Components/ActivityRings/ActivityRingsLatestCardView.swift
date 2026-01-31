//
//  ActivityRingsLatestCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct ActivityRingsLatestCardView: View {
    private let day: ActivityRingsDay

    public init(day: ActivityRingsDay) {
        self.day = day
    }

    public var body: some View {
        HStack(spacing: 16) {
            ActivityRingsStackView(
                moveProgress: day.moveProgress,
                exerciseProgress: day.exerciseProgress,
                standProgress: day.standProgress,
                size: 96
            )

            VStack(alignment: .leading, spacing: 8) {
                Text("Activity Rings")
                    .font(.headline)
                Text(day.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Move: \(Int(day.moveValue.rounded())) / \(Int(day.moveGoal.rounded())) kcal")
                    Text("Exercise: \(Int(day.exerciseMinutes.rounded())) / \(Int(day.exerciseGoal.rounded())) min")
                    Text("Stand: \(Int(day.standHours.rounded())) / \(Int(day.standGoal.rounded())) hr")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.secondary.opacity(0.08))
        )
    }
}

#if DEBUG
#Preview {
    ActivityRingsLatestCardView(
        day: ActivityRingsDay(
            date: Date(),
            moveValue: 420,
            moveGoal: 600,
            exerciseMinutes: 18,
            exerciseGoal: 30,
            standHours: 7,
            standGoal: 12
        )
    )
    .padding()
}
#endif
