//
//  ActivityHighlightsInsightDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct ActivityHighlightsInsightDetailView: View {
    private let insight: InsightItem

    public init(insight: InsightItem) {
        self.insight = insight
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ActivityHighlightsInsightCardView(insight: insight)

                summarySection
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .navigationTitle(insight.title)
        .scrollIndicators(.hidden)
    }
}

private extension ActivityHighlightsInsightDetailView {
    var summarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Highlights")
                .font(.headline)
            Text("Based on the last 7 days.")
                .font(.caption)
                .foregroundStyle(.secondary)
            VStack(spacing: 12) {
                statCard(title: "Best Day", value: bestDayText, icon: "sparkles", tint: .pink)
                statCard(title: "Lowest Day", value: worstDayText, icon: "moon.stars", tint: .purple)
                statCard(title: "Weekly Avg", value: averageText, icon: "chart.bar", tint: .indigo)
                statCard(title: "Move Avg", value: averageMoveText, icon: "flame", tint: .red)
                statCard(title: "Exercise Avg", value: averageExerciseText, icon: "figure.run", tint: .green)
                statCard(title: "Stand Avg", value: averageStandText, icon: "figure.stand", tint: .blue)
                statCard(title: "Move vs goal", value: averageMoveGoalText, icon: "target", tint: .red)
                statCard(title: "Exercise vs goal", value: averageExerciseGoalText, icon: "target", tint: .green)
                statCard(title: "Stand vs goal", value: averageStandGoalText, icon: "target", tint: .blue)
            }
        }
        .padding(14)
        .background(Color(UIColor.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    var bestDayText: String {
        guard let date = insight.activityHighlights?.bestDayDate else { return "—" }
        let move = insight.activityHighlights?.bestDayMove ?? 0
        return "\(date.formatted(date: .abbreviated, time: .omitted)) • \(formatNumber(move)) kcal"
    }

    var averageText: String {
        guard let highlight = insight.activityHighlights else { return "—" }
        return "Move \(formatNumber(highlight.averageMove)) • Exercise \(formatNumber(highlight.averageExercise))"
    }

    var worstDayText: String {
        guard let date = insight.activityHighlights?.worstDayDate else { return "—" }
        let move = insight.activityHighlights?.worstDayMove ?? 0
        return "\(date.formatted(date: .abbreviated, time: .omitted)) • \(formatNumber(move)) kcal"
    }

    var averageMoveText: String {
        guard let highlight = insight.activityHighlights else { return "—" }
        return "\(formatNumber(highlight.averageMove)) kcal"
    }

    var averageExerciseText: String {
        guard let highlight = insight.activityHighlights else { return "—" }
        return "\(formatNumber(highlight.averageExercise)) min"
    }

    var averageStandText: String {
        guard let highlight = insight.activityHighlights else { return "—" }
        return "\(formatNumber(highlight.averageStand)) stand hrs"
    }

    var averageMoveGoalText: String {
        guard let highlight = insight.activityHighlights else { return "—" }
        return "\(formatNumber(highlight.averageMove)) / \(formatNumber(highlight.averageMoveGoal)) kcal"
    }

    var averageExerciseGoalText: String {
        guard let highlight = insight.activityHighlights else { return "—" }
        return "\(formatNumber(highlight.averageExercise)) / \(formatNumber(highlight.averageExerciseGoal)) min"
    }

    var averageStandGoalText: String {
        guard let highlight = insight.activityHighlights else { return "—" }
        return "\(formatNumber(highlight.averageStand)) / \(formatNumber(highlight.averageStandGoal)) stand hrs"
    }

    func statCard(title: String, value: String, icon: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(tint)
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(value)
                .font(.subheadline.weight(.semibold))
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "\(Int(value.rounded()))"
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        ActivityHighlightsInsightDetailView(
            insight: InsightItem(
                type: .activityHighlights,
                title: "Activity Highlights",
                summary: "Move 3,420 kcal • Exercise 220 min",
                detail: "Active 5/7 days • Stand 62 hr",
                status: "Strong",
                icon: "figure.walk",
                activityHighlights: ActivityHighlightsInsight(
                    recentDays: [],
                    previousDays: [],
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
    }
}
#endif
