//
//  ExerciseMinutesDayRowView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct ExerciseMinutesDayRowView: View {
    private let day: ExerciseMinutesDayDetail

    public init(day: ExerciseMinutesDayDetail) {
        self.day = day
    }

    public var body: some View {
        HStack(spacing: 12) {
            ActivityRingView(progress: day.progress, color: .green, lineWidth: 6)
                .frame(width: 28, height: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(day.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline.weight(.semibold))
                Text(goalText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(valueText)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 4)
    }
}

private extension ExerciseMinutesDayRowView {
    var valueText: String {
        if let goal = day.goalMinutes {
            return "\(Int(day.minutes.rounded()))m / \(Int(goal.rounded()))m"
        }
        return "\(Int(day.minutes.rounded()))m"
    }

    var goalText: String {
        if let goal = day.goalMinutes {
            return "Goal \(Int(goal.rounded()))m"
        }
        return "Goal —"
    }
}

#if DEBUG
#Preview {
    ExerciseMinutesDayRowView(
        day: ExerciseMinutesDayDetail(date: Date(), minutes: 74, goalMinutes: 90)
    )
    .padding()
}
#endif
