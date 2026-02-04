//
//  RecoveryReadinessInsightDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct RecoveryReadinessInsightDetailView: View {
    private let insight: InsightItem

    public init(insight: InsightItem) {
        self.insight = insight
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                RecoveryReadinessInsightCardView(insight: insight)
                baselineSection
                trendSection
                interpretationSection
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .navigationTitle(insight.title)
        .scrollIndicators(.hidden)
    }
}

private extension RecoveryReadinessInsightDetailView {
    var baselineSection: some View {
        sectionCard(title: "Today vs Baseline") {
            statRow(title: "Resting Heart Rate", value: restingComparisonText, icon: "heart.fill")
            statRow(title: "HRV (SDNN)", value: hrvComparisonText, icon: "waveform.path.ecg")
        }
    }

    var trendSection: some View {
        sectionCard(title: "Trend Direction") {
            trendRow(title: "Resting HR", trend: insight.recoveryReadiness?.restingTrend ?? .unknown)
            trendRow(title: "HRV", trend: insight.recoveryReadiness?.hrvTrend ?? .unknown)
        }
    }

    var interpretationSection: some View {
        sectionCard(title: "Interpretation") {
            Text(interpretationText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
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

    func statRow(title: String, value: String, icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.green)
                .frame(width: 22, height: 22)
                .background(Color.green.opacity(0.15), in: Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.subheadline.weight(.semibold))
            }
            Spacer()
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    func trendRow(title: String, trend: RecoveryReadinessTrend) -> some View {
        HStack(spacing: 10) {
            Image(systemName: trend.symbolName)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.green)
                .frame(width: 22, height: 22)
                .background(Color.green.opacity(0.15), in: Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(trend.label)
                    .font(.subheadline.weight(.semibold))
            }
            Spacer()
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    var restingComparisonText: String {
        guard let insight = insight.recoveryReadiness else { return "—" }
        let latest = insight.latestRestingBpm
        let baseline = insight.currentRestingAverage
        return comparisonText(latest: latest, baseline: baseline, unit: "bpm")
    }

    var hrvComparisonText: String {
        guard let insight = insight.recoveryReadiness else { return "—" }
        let latest = insight.latestHrvMilliseconds
        let baseline = insight.currentHrvAverage
        return comparisonText(latest: latest, baseline: baseline, unit: "ms")
    }

    func comparisonText(latest: Double?, baseline: Double?, unit: String) -> String {
        guard let latest, let baseline else { return "—" }
        let delta = latest - baseline
        let deltaText = delta == 0 ? "no change" : "\(delta > 0 ? "+" : "")\(formatNumber(delta)) \(unit)"
        return "\(formatNumber(latest)) \(unit) • Baseline \(formatNumber(baseline)) \(unit) (\(deltaText))"
    }

    var interpretationText: String {
        guard let insight = insight.recoveryReadiness else { return "Recovery signals are unavailable today." }
        switch insight.status {
        case .ready:
            return "Resting HR is trending down while HRV is trending up. Your body looks ready for a stronger session."
        case .strained:
            return "Resting HR is trending up while HRV is trending down. Consider lighter training or recovery."
        case .steady:
            return "Signals are mixed or steady. Keep an eye on how you feel and stay consistent."
        case .unclear:
            return "Not enough data to interpret recovery right now."
        }
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
        RecoveryReadinessInsightDetailView(
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
    }
}
#endif
