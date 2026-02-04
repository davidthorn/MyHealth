//
//  WorkoutIntensityDistributionInsightCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct WorkoutIntensityDistributionInsightCardView: View {
    @StateObject private var viewModel: WorkoutIntensityDistributionInsightCardViewModel

    public init(insight: InsightItem) {
        _viewModel = StateObject(wrappedValue: WorkoutIntensityDistributionInsightCardViewModel(insight: insight))
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            summary
            WorkoutIntensityBarView(
                lowFraction: viewModel.lowFraction,
                moderateFraction: viewModel.moderateFraction,
                highFraction: viewModel.highFraction
            )
            HStack(spacing: 10) {
                valuePill(title: "Low", value: viewModel.lowMinutesText, color: .blue)
                valuePill(title: "Mod", value: viewModel.moderateMinutesText, color: .orange)
                valuePill(title: "High", value: viewModel.highMinutesText, color: .red)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
}

private extension WorkoutIntensityDistributionInsightCardView {
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

    func valuePill(title: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("\(value) min")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(color)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(UIColor.systemBackground))
        )
    }
}

#if DEBUG
#Preview {
    WorkoutIntensityDistributionInsightCardView(
        insight: InsightItem(
            type: .workoutIntensityDistribution,
            title: "Workout Intensity",
            summary: "180 min • 4 workouts",
            detail: "Low 40% • Mod 35% • High 25%",
            status: "Balanced",
            icon: "speedometer",
            workoutIntensityDistribution: WorkoutIntensityDistributionInsight(
                windowStart: Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date(),
                windowEnd: Date(),
                lowMinutes: 72,
                moderateMinutes: 63,
                highMinutes: 45,
                workoutCount: 4,
                status: .balanced
            )
        )
    )
    .padding()
}
#endif
