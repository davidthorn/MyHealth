//
//  ActivityHighlightsInsightCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct ActivityHighlightsInsightCardView: View {
    private let insight: InsightItem

    public init(insight: InsightItem) {
        self.insight = insight
    }

    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.18, green: 0.66, blue: 0.95),
                            Color(red: 0.09, green: 0.44, blue: 0.88)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text(insight.title)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                    Spacer()
                    Text(insight.status)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.9))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.18), in: Capsule())
                }
                Text("Last 7 days")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))

                if let highlight = insight.activityHighlights {
                    HStack(spacing: 12) {
                        metricChip(title: "Move", value: numberText(highlight.totalMove), unit: "kcal", tint: .red)
                        metricChip(title: "Exercise", value: numberText(highlight.totalExerciseMinutes), unit: "min", tint: .green)
                        metricChip(title: "Stand", value: numberText(highlight.totalStandHours), unit: "stand hrs", tint: .blue)
                    }

                    HStack(spacing: 10) {
                        pill(text: "Active \(highlight.activeDays)/\(highlight.recentDays.count) days", icon: "bolt.fill")
                        pill(text: "Rings closed \(highlight.daysWithRingClosed)/\(highlight.recentDays.count)", icon: "seal.fill")
                        if let bestDate = highlight.bestDayDate {
                            pill(text: "Best day \(bestDate.formatted(date: .abbreviated, time: .omitted))", icon: "star.fill")
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(insight.summary)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                    Text(insight.detail)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.85))
                }
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity)
    }
}

private extension ActivityHighlightsInsightCardView {
    func metricChip(title: String, value: String, unit: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.8))
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.white)
                Text(unit)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(tint.opacity(0.25), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    func pill(text: String, icon: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption2.weight(.semibold))
            Text(text)
                .font(.caption)
        }
        .foregroundStyle(.white.opacity(0.9))
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.18), in: Capsule())
    }

    func numberText(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "\(Int(value.rounded()))"
    }
}

#if DEBUG
#Preview {
    let days = [
        ActivityRingsDay(
            date: Date(),
            moveValue: 520,
            moveGoal: 600,
            exerciseMinutes: 32,
            exerciseGoal: 30,
            standHours: 10,
            standGoal: 12
        )
    ]
    ActivityHighlightsInsightCardView(
        insight: InsightItem(
            type: .activityHighlights,
            title: "Activity Highlights",
            summary: "Move 3,420 kcal • Exercise 220 min",
            detail: "Active 5/7 days • Stand 62 hr",
            status: "Strong",
            icon: "figure.walk",
            activityHighlights: ActivityHighlightsInsight(
                recentDays: days,
                previousDays: days,
                totalMove: 3420,
                totalExerciseMinutes: 220,
                totalStandHours: 62,
                activeDays: 5,
                daysWithRingClosed: 6,
                bestDayDate: Date(),
                bestDayMove: 620,
                worstDayDate: Calendar.current.date(byAdding: .day, value: -2, to: Date()),
                worstDayMove: 220,
                averageMove: 488,
                averageExercise: 31,
                averageStand: 9,
                averageMoveGoal: 600,
                averageExerciseGoal: 30,
                averageStandGoal: 12
            )
        )
    )
    .padding()
}
#endif
