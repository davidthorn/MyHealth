//
//  WorkoutIntensityDistributionInsightDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct WorkoutIntensityDistributionInsightDetailView: View {
    @StateObject private var viewModel: WorkoutIntensityDistributionInsightDetailViewModel

    public init(insight: InsightItem) {
        _viewModel = StateObject(wrappedValue: WorkoutIntensityDistributionInsightDetailViewModel(insight: insight))
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                WorkoutIntensityDistributionInsightCardView(insight: viewModel.insight)
                distributionSection
                interpretationSection
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .navigationTitle(viewModel.title)
        .scrollIndicators(.hidden)
    }
}

private extension WorkoutIntensityDistributionInsightDetailView {
    var distributionSection: some View {
        sectionCard(title: "Intensity Distribution") {
            WorkoutIntensityBarView(
                lowFraction: viewModel.lowFraction,
                moderateFraction: viewModel.moderateFraction,
                highFraction: viewModel.highFraction
            )
            .padding(.vertical, 6)

            HStack(spacing: 10) {
                detailPill(title: "Low", value: viewModel.lowMinutesText, color: .blue)
                detailPill(title: "Moderate", value: viewModel.moderateMinutesText, color: .orange)
                detailPill(title: "High", value: viewModel.highMinutesText, color: .red)
            }
        }
    }

    var interpretationSection: some View {
        sectionCard(title: "Balance") {
            Text(viewModel.statusText)
                .font(.headline)
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

    func detailPill(title: String, value: String, color: Color) -> some View {
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
    NavigationStack {
        WorkoutIntensityDistributionInsightDetailView(
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
    }
}
#endif
