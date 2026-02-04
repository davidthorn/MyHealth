//
//  WorkoutHighlightsInsightCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct WorkoutHighlightsInsightCardView: View {
    private let insight: InsightItem

    public init(insight: InsightItem) {
        self.insight = insight
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            metricsRow
            if let detail = insight.workoutHighlights {
                highlights(detail)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [Color(red: 0.12, green: 0.2, blue: 0.34), Color(red: 0.06, green: 0.1, blue: 0.2)],
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

private extension WorkoutHighlightsInsightCardView {
    var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(insight.title)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text("Last 7 days")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }
            Spacer()
            Image(systemName: insight.icon)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
                .padding(10)
                .background(Color.white.opacity(0.16), in: Circle())
        }
    }

    var metricsRow: some View {
        HStack(spacing: 12) {
            metricPill(title: "Workouts", value: workoutCountText)
            metricPill(title: "Minutes", value: durationText)
        }
        .frame(maxWidth: .infinity)
    }

    func highlights(_ detail: WorkoutHighlightsInsight) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            if let averageHeartRate = detail.averageHeartRate {
                Text("Avg HR \(formatNumber(averageHeartRate)) bpm")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
            }
            if let peakHeartRate = detail.peakHeartRate {
                Text("Peak \(formatNumber(peakHeartRate)) bpm")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.75))
            }
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

    var workoutCountText: String {
        guard let detail = insight.workoutHighlights else { return "—" }
        return "\(detail.workoutCount)"
    }

    var durationText: String {
        guard let detail = insight.workoutHighlights else { return "—" }
        return formatNumber(detail.totalDurationMinutes)
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
    WorkoutHighlightsInsightCardView(
        insight: InsightItem(
            type: .workoutHighlights,
            title: "Workout Highlights",
            summary: "4 workouts • 210 min",
            detail: "Avg HR 142 bpm • Peak 176 bpm",
            status: "Strong",
            icon: "figure.run",
            workoutHighlights: WorkoutHighlightsInsight(
                windowStart: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
                windowEnd: Date(),
                workoutCount: 4,
                totalDurationMinutes: 210,
                totalDistanceMeters: 18000,
                averageHeartRate: 142,
                peakHeartRate: 176,
                mostIntenseWorkout: WorkoutInsightSummary(
                    id: UUID(),
                    type: .running,
                    startedAt: Date(),
                    durationMinutes: 48,
                    distanceMeters: 7200,
                    averageHeartRate: 152,
                    peakHeartRate: 176
                ),
                longestWorkout: WorkoutInsightSummary(
                    id: UUID(),
                    type: .walking,
                    startedAt: Date(),
                    durationMinutes: 62,
                    distanceMeters: 6100,
                    averageHeartRate: 128,
                    peakHeartRate: 148
                ),
                recentWorkouts: []
            )
        )
    )
    .padding()
    .background(Color.black)
}
#endif
