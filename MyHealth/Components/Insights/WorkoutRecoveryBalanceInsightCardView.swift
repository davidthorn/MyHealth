//
//  WorkoutRecoveryBalanceInsightCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct WorkoutRecoveryBalanceInsightCardView: View {
    @StateObject private var viewModel: WorkoutRecoveryBalanceInsightCardViewModel

    public init(insight: InsightItem) {
        _viewModel = StateObject(wrappedValue: WorkoutRecoveryBalanceInsightCardViewModel(insight: insight))
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            summary
            HStack(spacing: 10) {
                loadPill
                recoveryPill
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
}

private extension WorkoutRecoveryBalanceInsightCardView {
    var header: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: viewModel.iconName)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(viewModel.statusColor, in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.title)
                    .font(.headline)
                Text(viewModel.statusText)
                    .font(.subheadline)
                    .foregroundStyle(viewModel.statusColor)
            }
            Spacer()
        }
    }

    var summary: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.summaryText)
                .font(.subheadline.weight(.semibold))
            Text(viewModel.detailText)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    var loadPill: some View {
        pill(title: "Training Load", value: loadText, icon: "flame")
    }

    var recoveryPill: some View {
        pill(title: "Recovery", value: recoveryText, icon: "heart")
    }

    func pill(title: String, value: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption.weight(.semibold))
                .foregroundStyle(viewModel.statusColor)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
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

    var loadText: String {
        viewModel.loadText
    }

    var recoveryText: String {
        viewModel.recoveryText
    }
}

#if DEBUG
#Preview {
    WorkoutRecoveryBalanceInsightCardView(
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
    .padding()
}
#endif
