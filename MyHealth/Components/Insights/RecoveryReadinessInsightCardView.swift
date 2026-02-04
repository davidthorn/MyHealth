//
//  RecoveryReadinessInsightCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct RecoveryReadinessInsightCardView: View {
    private let insight: InsightItem

    public init(insight: InsightItem) {
        self.insight = insight
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            metricsRow
            trendsRow
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [Color(red: 0.05, green: 0.28, blue: 0.22), Color(red: 0.02, green: 0.18, blue: 0.14)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 18, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}

private extension RecoveryReadinessInsightCardView {
    var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(insight.title)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text("Last 14 days")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }
            Spacer()
            statusBadge
        }
    }

    var statusBadge: some View {
        Text(insight.recoveryReadiness?.status.title ?? "Unclear")
            .font(.caption.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.16), in: Capsule())
    }

    var metricsRow: some View {
        HStack(spacing: 12) {
            metricPill(title: "Resting HR", value: restingText)
            metricPill(title: "HRV", value: hrvText)
        }
    }

    var trendsRow: some View {
        HStack(spacing: 12) {
            trendPill(title: "RHR Trend", trend: insight.recoveryReadiness?.restingTrend ?? .unknown)
            trendPill(title: "HRV Trend", trend: insight.recoveryReadiness?.hrvTrend ?? .unknown)
        }
    }

    func metricPill(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.7))
            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    func trendPill(title: String, trend: RecoveryReadinessTrend) -> some View {
        HStack(spacing: 6) {
            Image(systemName: trend.symbolName)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.7))
                Text(trend.label)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    var restingText: String {
        guard let value = insight.recoveryReadiness?.latestRestingBpm else { return "—" }
        return "\(formatNumber(value)) bpm"
    }

    var hrvText: String {
        guard let value = insight.recoveryReadiness?.latestHrvMilliseconds else { return "—" }
        return "\(formatNumber(value)) ms"
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
    RecoveryReadinessInsightCardView(
        insight: InsightItem(
            type: .recoveryReadiness,
            title: "Recovery Readiness",
            summary: "RHR 54 bpm • HRV 62 ms",
            detail: "7-day trend: RHR Down • HRV Up",
            status: "Ready",
            icon: "heart.circle",
            recoveryReadiness: RecoveryReadinessInsight(
                windowStart: Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date(),
                windowEnd: Date(),
                latestRestingBpm: 54,
                latestHrvMilliseconds: 62,
                currentRestingAverage: 55,
                previousRestingAverage: 58,
                currentHrvAverage: 60,
                previousHrvAverage: 54,
                restingTrend: .down,
                hrvTrend: .up,
                status: .ready
            )
        )
    )
    .padding()
    .background(Color.black)
}
#endif
