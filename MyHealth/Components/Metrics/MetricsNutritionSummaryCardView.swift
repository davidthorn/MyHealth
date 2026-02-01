//
//  MetricsNutritionSummaryCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct MetricsNutritionSummaryCardView: View {
    private let summary: NutritionDaySummary

    public init(summary: NutritionDaySummary) {
        self.summary = summary
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Nutrition Today")
                        .font(.headline)
                    Text(summary.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "leaf.circle.fill")
                    .font(.title3)
                    .foregroundStyle(Color.accentColor)
            }

            VStack(spacing: 10) {
                ForEach(summary.totals.prefix(6)) { total in
                    NutritionSummaryRowView(total: total)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color(.secondarySystemBackground))
                        )
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.accentColor.opacity(0.18),
                            Color.accentColor.opacity(0.06)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.accentColor.opacity(0.18), lineWidth: 1)
        )
    }
}

#if DEBUG
#Preview("Nutrition Summary Card") {
    MetricsNutritionSummaryCardView(
        summary: NutritionDaySummary(
            date: Date(),
            totals: [
                NutritionDayTotal(type: .protein, value: 54.2, unit: "g"),
                NutritionDayTotal(type: .carbohydrate, value: 110.5, unit: "g"),
                NutritionDayTotal(type: .fatTotal, value: 32.1, unit: "g")
            ]
        )
    )
    .padding()
}
#endif
