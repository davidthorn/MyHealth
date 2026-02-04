//
//  CardioFitnessTrendInsightCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct CardioFitnessTrendInsightCardView: View {
    private let insight: InsightItem

    public init(insight: InsightItem) {
        self.insight = insight
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            summary
            HStack(spacing: 10) {
                valuePill(title: "Latest", value: latestText, icon: "wind")
                valuePill(title: "30D Avg", value: averageText, icon: "chart.line.uptrend.xyaxis")
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
}

private extension CardioFitnessTrendInsightCardView {
    var header: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: insight.icon)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(accentColor, in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(insight.title)
                    .font(.headline)
                Text(insight.status)
                    .font(.subheadline)
                    .foregroundStyle(accentColor)
            }
            Spacer()
        }
    }

    var summary: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(insight.summary)
                .font(.subheadline.weight(.semibold))
            Text(insight.detail)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    func valuePill(title: String, value: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption.weight(.semibold))
                .foregroundStyle(accentColor)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.subheadline.weight(.semibold))
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(UIColor.systemBackground))
        )
    }

    var latestText: String {
        guard let latest = insight.cardioFitnessTrend?.latestReading else { return "—" }
        return "\(formatNumber(latest.vo2Max))"
    }

    var averageText: String {
        guard let average = insight.cardioFitnessTrend?.currentAverage else { return "—" }
        return "\(formatNumber(average))"
    }

    var accentColor: Color {
        .teal
    }

    func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

#if DEBUG
#Preview {
    CardioFitnessTrendInsightCardView(
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
                readings: [CardioFitnessReading(vo2Max: 42.6, date: Date(), startDate: Date(), endDate: Date())],
                dayStats: [CardioFitnessDayStats(date: Date(), averageVo2Max: 41.2, minVo2Max: 39.8, maxVo2Max: 43.0)],
                latestReading: CardioFitnessReading(vo2Max: 42.6, date: Date(), startDate: Date(), endDate: Date()),
                currentAverage: 40.8,
                previousAverage: 39.0,
                delta: 1.8,
                status: .rising
            )
        )
    )
    .padding()
}
#endif
