//
//  SleepTrainingBalanceInsightCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct SleepTrainingBalanceInsightCardView: View {
    @StateObject private var viewModel: SleepTrainingBalanceInsightCardViewModel

    public init(insight: InsightItem) {
        _viewModel = StateObject(wrappedValue: SleepTrainingBalanceInsightCardViewModel(insight: insight))
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            summary
            HStack(spacing: 10) {
                valuePill(title: "Sleep", value: viewModel.sleepText, icon: "bed.double.fill")
                valuePill(title: "Load", value: viewModel.loadText, icon: "flame")
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
}

private extension SleepTrainingBalanceInsightCardView {
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

    func valuePill(title: String, value: String, icon: String) -> some View {
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
}

#if DEBUG
#Preview {
    SleepTrainingBalanceInsightCardView(
        insight: InsightItem(
            type: .sleepTrainingBalance,
            title: "Sleep vs Training",
            summary: "7.2 hr avg • 240 min load",
            detail: "Sleep Up 0.4 hr • Load Up 30 min",
            status: "Balanced",
            icon: "bed.double.fill",
            sleepTrainingBalance: SleepTrainingBalanceInsight(
                windowStart: Calendar.current.date(byAdding: .day, value: -13, to: Date()) ?? Date(),
                windowEnd: Date(),
                currentWeekStart: Calendar.current.startOfDay(for: Date()),
                currentWeekEnd: Calendar.current.date(byAdding: .day, value: 7, to: Calendar.current.startOfDay(for: Date())) ?? Date(),
                previousWeekStart: Calendar.current.date(byAdding: .day, value: -7, to: Calendar.current.startOfDay(for: Date())) ?? Date(),
                previousWeekEnd: Calendar.current.startOfDay(for: Date()),
                currentSleepHours: 7.2,
                previousSleepHours: 6.8,
                sleepDeltaHours: 0.4,
                currentLoadMinutes: 240,
                previousLoadMinutes: 210,
                loadDeltaMinutes: 30,
                workoutCount: 4,
                status: .balanced
            )
        )
    )
    .padding()
}
#endif
