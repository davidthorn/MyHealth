//
//  WorkoutLoadTrendInsightDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct WorkoutLoadTrendInsightDetailView: View {
    @StateObject private var viewModel: WorkoutLoadTrendInsightDetailViewModel

    public init(insight: InsightItem) {
        _viewModel = StateObject(wrappedValue: WorkoutLoadTrendInsightDetailViewModel(insight: insight))
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                WorkoutLoadTrendInsightCardView(insight: viewModel.insight)
                summarySection
                detailSection
                interpretationSection
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .navigationTitle(viewModel.title)
        .scrollIndicators(.hidden)
    }
}

private extension WorkoutLoadTrendInsightDetailView {
    var summarySection: some View {
        sectionCard(title: "Summary") {
            statRow(title: viewModel.currentWeekLabel, value: viewModel.currentSummaryText, icon: "calendar")
            statRow(title: viewModel.previousWeekLabel, value: viewModel.previousSummaryText, icon: "calendar")
        }
    }

    var detailSection: some View {
        sectionCard(title: "Load Comparison") {
            statRow(title: "Load score", value: viewModel.loadComparisonText, icon: "gauge")
            statRow(title: "Workout count", value: viewModel.workoutCountText, icon: "figure.walk")
            Text("Load score blends workout minutes with average heart rate when available.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    var interpretationSection: some View {
        sectionCard(title: "Interpretation") {
            Text(viewModel.interpretationText)
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
                .foregroundStyle(.purple)
                .frame(width: 22, height: 22)
                .background(Color.purple.opacity(0.15), in: Circle())
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

    
}

#if DEBUG
#Preview {
    NavigationStack {
        WorkoutLoadTrendInsightDetailView(
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
    }
}
#endif
