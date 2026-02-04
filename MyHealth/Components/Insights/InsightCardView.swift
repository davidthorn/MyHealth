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
        case .activityConsistency:
            return .green
        }
    }
}

#if DEBUG
#Preview {
    InsightCardView(
        insight: InsightItem(
            type: .activityConsistency,
            title: "Activity Consistency",
            summary: "Closed all rings 4/7 days",
            detail: "Move goal met 5 days • Exercise goal met 4 days • Stand goal met 6 days",
            status: "Steady",
            icon: "figure.walk"
        )
    )
    .padding()
}
#endif
