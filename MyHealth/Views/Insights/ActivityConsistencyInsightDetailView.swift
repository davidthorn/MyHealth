//
//  ActivityConsistencyInsightDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct ActivityConsistencyInsightDetailView: View {
    private let insight: InsightItem

    public init(insight: InsightItem) {
        self.insight = insight
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                InsightCardView(insight: insight)

                VStack(alignment: .leading, spacing: 8) {
                    Text("How this is calculated")
                        .font(.headline)
                    Text("We look at the last 7 days of Activity Rings and count how many days each goal was achieved.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(14)
                .background(Color(UIColor.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .navigationTitle(insight.title)
        .scrollIndicators(.hidden)
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        ActivityConsistencyInsightDetailView(
            insight: InsightItem(
                type: .activityConsistency,
                title: "Activity Consistency",
                summary: "Closed all rings 4/7 days",
                detail: "Move goal met 5 days • Exercise goal met 4 days • Stand goal met 6 days",
                status: "Steady",
                icon: "figure.walk"
            )
        )
    }
}
#endif
