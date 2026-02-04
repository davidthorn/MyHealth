//
//  WorkoutLoadTrendInsightCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct WorkoutLoadTrendInsightCardView: View {
    private let insight: InsightItem

    public init(insight: InsightItem) {
        self.insight = insight
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            metricsRow
            trendRow
            loadTip
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [Color(red: 0.3, green: 0.12, blue: 0.45), Color(red: 0.18, green: 0.06, blue: 0.28)],
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

private extension WorkoutLoadTrendInsightCardView {
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
        Text(insight.workoutLoadTrend?.status.title ?? "Unclear")
            .font(.caption.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.16), in: Capsule())
    }

    var metricsRow: some View {
        HStack(spacing: 12) {
            metricPill(title: currentWeekLabel, value: currentMinutesText)
            metricPill(title: previousWeekLabel, value: previousMinutesText)
        }
    }

    var trendRow: some View {
        HStack(spacing: 12) {
            trendPill(title: "Load Trend", status: insight.workoutLoadTrend?.status ?? .unclear)
            metricPill(title: "Delta", value: deltaText)
        }
    }

    var loadTip: some View {
        Text("Load score blends workout minutes with average heart rate when available.")
            .font(.caption2)
            .foregroundStyle(.white.opacity(0.7))
            .frame(maxWidth: .infinity, alignment: .leading)
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
        .frame(minHeight: 56, maxHeight: 60)
        .background(Color.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    func trendPill(title: String, status: WorkoutLoadTrendStatus) -> some View {
        HStack(spacing: 6) {
            Image(systemName: statusSymbol(status))
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.7))
                Text(status.title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 56, maxHeight: 60)
        .background(Color.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    var currentMinutesText: String {
        guard let minutes = insight.workoutLoadTrend?.currentMinutes else { return "—" }
        return "\(formatNumber(minutes)) min"
    }

    var previousMinutesText: String {
        guard let minutes = insight.workoutLoadTrend?.previousMinutes else { return "—" }
        return "\(formatNumber(minutes)) min"
    }

    var currentWeekLabel: String {
        guard let insight = insight.workoutLoadTrend else { return "This Week" }
        return "This Week \(dateRangeText(start: insight.currentWeekStart, end: insight.currentWeekEnd))"
    }

    var previousWeekLabel: String {
        guard let insight = insight.workoutLoadTrend else { return "Last Week" }
        return "Last Week \(dateRangeText(start: insight.previousWeekStart, end: insight.previousWeekEnd))"
    }

    var deltaText: String {
        guard let delta = insight.workoutLoadTrend?.delta else { return "—" }
        let prefix = delta >= 0 ? "+" : ""
        return "\(prefix)\(formatNumber(delta))"
    }

    func statusSymbol(_ status: WorkoutLoadTrendStatus) -> String {
        switch status {
        case .rampingUp:
            return "arrow.up.right"
        case .steady:
            return "arrow.right"
        case .tapering:
            return "arrow.down.right"
        case .unclear:
            return "questionmark"
        }
    }

    func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "\(Int(value.rounded()))"
    }

    func dateRangeText(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let endDay = Calendar.current.date(byAdding: .day, value: -1, to: end) ?? end
        return "\(formatter.string(from: start))–\(formatter.string(from: endDay))"
    }
}

#if DEBUG
#Preview {
    WorkoutLoadTrendInsightCardView(
        insight: InsightItem(
            type: .workoutLoadTrend,
            title: "Workout Load Trend",
            summary: "This week 230 min • Last week 180 min",
            detail: "Load 260 vs 210",
            status: "Ramping Up",
            icon: "chart.line.uptrend.xyaxis",
            workoutLoadTrend: WorkoutLoadTrendInsight(
                windowStart: Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date(),
                windowEnd: Date(),
                currentWeekStart: Calendar.current.startOfDay(for: Date()),
                currentWeekEnd: Calendar.current.date(byAdding: .day, value: 7, to: Calendar.current.startOfDay(for: Date())) ?? Date(),
                previousWeekStart: Calendar.current.date(byAdding: .day, value: -7, to: Calendar.current.startOfDay(for: Date())) ?? Date(),
                previousWeekEnd: Calendar.current.startOfDay(for: Date()),
                currentLoad: 260,
                previousLoad: 210,
                delta: 50,
                status: .rampingUp,
                currentWorkoutCount: 5,
                previousWorkoutCount: 4,
                currentMinutes: 230,
                previousMinutes: 180
            )
        )
    )
    .padding()
    .background(Color.black)
}
#endif
