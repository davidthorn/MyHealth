//
//  WorkoutRecoveryBalanceInsightDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct WorkoutRecoveryBalanceInsightDetailView: View {
    @StateObject private var viewModel: WorkoutRecoveryBalanceInsightDetailViewModel

    public init(insight: InsightItem) {
        _viewModel = StateObject(wrappedValue: WorkoutRecoveryBalanceInsightDetailViewModel(insight: insight))
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                WorkoutRecoveryBalanceInsightCardView(insight: viewModel.insight)
                loadSection
                recoverySection
                interpretationSection
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .navigationTitle(viewModel.title)
        .scrollIndicators(.hidden)
    }
}

private extension WorkoutRecoveryBalanceInsightDetailView {
    var loadSection: some View {
        sectionCard(title: "Training Load") {
            statRow(title: viewModel.currentWeekLabel, value: viewModel.loadMinutesText, icon: "calendar")
            statRow(title: "Load score", value: viewModel.loadScoreText, icon: "flame")
            statRow(title: "Workout count", value: viewModel.workoutCountText, icon: "figure.run")
        }
    }

    var recoverySection: some View {
        sectionCard(title: "Recovery Signals") {
            statRow(title: "Resting HR", value: viewModel.latestRestingText, icon: "heart")
            statRow(title: "HRV", value: viewModel.latestHrvText, icon: "waveform.path.ecg")
            statRow(title: "Resting trend", value: viewModel.restingTrendText, icon: "arrow.up.right")
            statRow(title: "HRV trend", value: viewModel.hrvTrendText, icon: "arrow.up.right")
        }
    }

    var interpretationSection: some View {
        sectionCard(title: "Balance") {
            HStack(spacing: 10) {
                Image(systemName: "bolt.heart")
                    .font(.headline)
                    .foregroundStyle(statusColor)
                    .frame(width: 32, height: 32)
                    .background(statusColor.opacity(0.15), in: Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.statusText)
                        .font(.headline)
                    Text(viewModel.interpretationText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
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

    func statRow(title: String, value: String, icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.caption.weight(.semibold))
                .foregroundStyle(statusColor)
                .frame(width: 22, height: 22)
                .background(statusColor.opacity(0.15), in: Circle())
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

    var statusColor: Color {
        guard let status = viewModel.insight.workoutRecoveryBalance?.status else { return .gray }
        switch status {
        case .balanced:
            return .green
        case .overreaching:
            return .orange
        case .readyForMore:
            return .blue
        case .unclear:
            return .gray
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        WorkoutRecoveryBalanceInsightDetailView(
            insight: InsightItem(
                type: .workoutRecoveryBalance,
                title: "Workout Recovery Balance",
                summary: "240 min • 4 workouts • Ready",
                detail: "RHR 55 bpm • HRV 62 ms",
                status: "Balanced",
                icon: "bolt.heart",
                workoutRecoveryBalance: WorkoutRecoveryBalanceInsight(
                    windowStart: Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date(),
                    windowEnd: Date(),
                    currentWeekStart: Calendar.current.startOfDay(for: Date()),
                    currentWeekEnd: Calendar.current.date(byAdding: .day, value: 7, to: Calendar.current.startOfDay(for: Date())) ?? Date(),
                    loadMinutes: 240,
                    loadScore: 260,
                    workoutCount: 4,
                    loadStatus: .steady,
                    latestRestingBpm: 55,
                    latestHrvMilliseconds: 62,
                    restingTrend: .down,
                    hrvTrend: .up,
                    recoveryStatus: .ready,
                    status: .balanced
                )
            )
        )
    }
}
#endif
