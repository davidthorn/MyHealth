//
//  MetricsNutritionSummaryCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct MetricsNutritionSummaryCardView: View {
    private let summary: NutritionWindowSummary
    @Binding private var selectedWindow: NutritionWindow
    private let windows: [NutritionWindow]

    public init(
        summary: NutritionWindowSummary,
        selectedWindow: Binding<NutritionWindow>,
        windows: [NutritionWindow]
    ) {
        self.summary = summary
        self._selectedWindow = selectedWindow
        self.windows = windows
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Nutrition")
                        .font(.headline)
                    Text(summary.windowLabel)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "leaf.circle.fill")
                    .font(.title3)
                    .foregroundStyle(Color.accentColor)
            }

            Picker("Window", selection: $selectedWindow) {
                ForEach(windows) { window in
                    Text(window.title).tag(window)
                }
            }
            .pickerStyle(.segmented)

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
        summary: NutritionWindowSummary(
            window: .today,
            startDate: Calendar.current.startOfDay(for: Date()),
            endDate: Calendar.current.startOfDay(for: Date()).addingTimeInterval(24 * 60 * 60),
            totals: [
                NutritionDayTotal(type: .protein, value: 54.2, unit: "g"),
                NutritionDayTotal(type: .carbohydrate, value: 110.5, unit: "g"),
                NutritionDayTotal(type: .fatTotal, value: 32.1, unit: "g")
            ]
        ),
        selectedWindow: .constant(.today),
        windows: NutritionWindow.allCases
    )
    .padding()
}
#endif
