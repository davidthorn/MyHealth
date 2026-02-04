//
//  CardioFitnessTrendInsightDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct CardioFitnessTrendInsightDetailView: View {
    @StateObject private var viewModel: CardioFitnessTrendInsightDetailViewModel

    public init(insight: InsightItem) {
        _viewModel = StateObject(wrappedValue: CardioFitnessTrendInsightDetailViewModel(insight: insight))
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CardioFitnessTrendInsightCardView(insight: viewModel.insight)
                latestSection
                trendSection
                chartSection
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .navigationTitle(viewModel.title)
        .scrollIndicators(.hidden)
    }
}

private extension CardioFitnessTrendInsightDetailView {
    var latestSection: some View {
        sectionCard(title: "Latest Reading") {
            statRow(title: "VO₂ max", value: viewModel.latestValueText, unit: "ml/kg/min", icon: "wind")
            statRow(title: "Date", value: viewModel.latestDateText, unit: nil, icon: "calendar")
        }
    }

    var trendSection: some View {
        sectionCard(title: "30‑Day Trend") {
            statRow(title: "Current avg", value: viewModel.currentAverageText, unit: "ml/kg/min", icon: "chart.line.uptrend.xyaxis")
            statRow(title: "Previous avg", value: viewModel.previousAverageText, unit: "ml/kg/min", icon: "clock.arrow.circlepath")
            statRow(title: "Change", value: viewModel.deltaText, unit: "ml/kg/min", icon: "arrow.up.right")
        }
    }

    var chartSection: some View {
        sectionCard(title: "6‑Month Trend") {
            CardioFitnessLineChartView(readings: viewModel.readings, window: viewModel.window)
                .frame(height: 180)
        }
    }

    func sectionCard(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content()
        }
        .padding(14)
        .background(Color(UIColor.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    func statRow(title: String, value: String, unit: String?, icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.teal)
                .frame(width: 22, height: 22)
                .background(Color.teal.opacity(0.15), in: Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                HStack(spacing: 4) {
                    Text(value)
                        .font(.subheadline.weight(.semibold))
                    if let unit {
                        Text(unit)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            Spacer()
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        CardioFitnessTrendInsightDetailView(
            insight: InsightItem(
                type: .cardioFitnessTrend,
                title: "VO₂ Max Trend",
                summary: "Latest 42.6 ml/kg/min • 40.8 avg",
                detail: "Up 1.8 vs prior period",
                status: "Rising",
                icon: "wind",
                cardioFitnessTrend: CardioFitnessTrendInsight(
                    windowStart: Calendar.current.date(byAdding: .day, value: -180, to: Date()) ?? Date(),
                    windowEnd: Date(),
                    readings: [
                        CardioFitnessReading(vo2Max: 40.6, date: Date().addingTimeInterval(-86400 * 3), startDate: Date(), endDate: Date()),
                        CardioFitnessReading(vo2Max: 41.2, date: Date().addingTimeInterval(-86400 * 2), startDate: Date(), endDate: Date()),
                        CardioFitnessReading(vo2Max: 42.6, date: Date(), startDate: Date(), endDate: Date())
                    ],
                    dayStats: [],
                    latestReading: CardioFitnessReading(vo2Max: 42.6, date: Date(), startDate: Date(), endDate: Date()),
                    currentAverage: 40.8,
                    previousAverage: 39.0,
                    delta: 1.8,
                    status: .rising
                )
            )
        )
    }
}
#endif
