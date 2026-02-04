//
//  InsightCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct InsightCardView: View {
    private let insight: InsightItem

    public init(insight: InsightItem) {
        self.insight = insight
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: insight.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(accentColor)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(insight.title)
                    .font(.headline)
                Text(insight.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(insight.detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
            Text(insight.status)
                .font(.caption.weight(.semibold))
                .foregroundStyle(accentColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(accentColor.opacity(0.12), in: Capsule())
        }
        .padding(14)
        .background(Color(UIColor.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private extension InsightCardView {
    var accentColor: Color {
        switch insight.type {
        case .activityHighlights:
            return .blue
        case .workoutHighlights:
            return .pink
        case .recoveryReadiness:
            return .green
        case .workoutLoadTrend:
            return .purple
        case .workoutRecoveryBalance:
            return .orange
        }
    }
}

#if DEBUG
#Preview {
    InsightCardView(
        insight: InsightItem(
            type: .activityHighlights,
            title: "Activity Highlights",
            summary: "Move 3,420 kcal • Exercise 220 min",
            detail: "Active 5/7 days • Stand 62 hr",
            status: "Strong",
            icon: "figure.walk"
        )
    )
    .padding()
}
#endif
