//
//  WorkoutHighlightsInsightDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct WorkoutHighlightsInsightDetailView: View {
    private let insight: InsightItem

    public init(insight: InsightItem) {
        self.insight = insight
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                WorkoutHighlightsInsightCardView(insight: insight)

                overviewSection
                intensitySection
                highlightSection
                recentWorkoutsSection
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .navigationTitle(insight.title)
        .scrollIndicators(.hidden)
    }
}

private extension WorkoutHighlightsInsightDetailView {
    var overviewSection: some View {
        sectionCard(title: "Overview") {
            HStack(spacing: 12) {
                statPill(title: "Workouts", value: workoutCountText)
                statPill(title: "Minutes", value: durationText)
            }
            if let distanceText {
                statRow(title: "Distance", value: distanceText, icon: "map")
            }
        }
    }

    var intensitySection: some View {
        sectionCard(title: "Intensity") {
            statRow(title: "Avg Heart Rate", value: averageHeartRateText, icon: "heart.fill")
            statRow(title: "Peak Heart Rate", value: peakHeartRateText, icon: "heart.circle")
        }
    }

    var highlightSection: some View {
        sectionCard(title: "Highlights") {
            statRow(title: "Most Intense", value: mostIntenseText, icon: "bolt.heart")
            statRow(title: "Longest Session", value: longestWorkoutText, icon: "clock.arrow.circlepath")
        }
    }

    var recentWorkoutsSection: some View {
        sectionCard(title: "Recent Workouts") {
            if let workouts = insight.workoutHighlights?.recentWorkouts, !workouts.isEmpty {
                VStack(spacing: 10) {
                    ForEach(workouts) { workout in
                        workoutRow(workout)
                    }
                }
            } else {
                Text("No workouts available.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
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

    func statPill(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline.weight(.semibold))
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    func statRow(title: String, value: String, icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.pink)
                .frame(width: 22, height: 22)
                .background(Color.pink.opacity(0.15), in: Circle())
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

    func workoutRow(_ workout: WorkoutInsightSummary) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(workout.type.displayName)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(workout.startedAt.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            HStack(spacing: 12) {
                labelValue("Duration", "\(formatNumber(workout.durationMinutes)) min")
                if let average = workout.averageHeartRate {
                    labelValue("Avg HR", "\(formatNumber(average)) bpm")
                }
                if let peak = workout.peakHeartRate {
                    labelValue("Peak", "\(formatNumber(peak)) bpm")
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    func labelValue(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.caption.weight(.semibold))
        }
    }

    var workoutCountText: String {
        guard let detail = insight.workoutHighlights else { return "—" }
        return "\(detail.workoutCount)"
    }

    var durationText: String {
        guard let detail = insight.workoutHighlights else { return "—" }
        return formatNumber(detail.totalDurationMinutes)
    }

    var distanceText: String? {
        guard let meters = insight.workoutHighlights?.totalDistanceMeters else { return nil }
        let km = meters / 1000
        return "\(formatNumber(km)) km"
    }

    var averageHeartRateText: String {
        guard let average = insight.workoutHighlights?.averageHeartRate else { return "—" }
        return "\(formatNumber(average)) bpm"
    }

    var peakHeartRateText: String {
        guard let peak = insight.workoutHighlights?.peakHeartRate else { return "—" }
        return "\(formatNumber(peak)) bpm"
    }

    var mostIntenseText: String {
        guard let workout = insight.workoutHighlights?.mostIntenseWorkout else { return "—" }
        return "\(workout.type.displayName) • \(formatNumber(workout.averageHeartRate ?? workout.peakHeartRate ?? 0)) bpm"
    }

    var longestWorkoutText: String {
        guard let workout = insight.workoutHighlights?.longestWorkout else { return "—" }
        return "\(workout.type.displayName) • \(formatNumber(workout.durationMinutes)) min"
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
        WorkoutHighlightsInsightDetailView(
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
                    recentWorkouts: [
                        WorkoutInsightSummary(
                            id: UUID(),
                            type: .cycling,
                            startedAt: Date(),
                            durationMinutes: 42,
                            distanceMeters: 9800,
                            averageHeartRate: 136,
                            peakHeartRate: 162
                        )
                    ]
                )
            )
        )
    }
}
#endif
