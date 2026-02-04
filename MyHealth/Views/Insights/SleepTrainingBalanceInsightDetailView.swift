//
//  SleepTrainingBalanceInsightDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct SleepTrainingBalanceInsightDetailView: View {
    @StateObject private var viewModel: SleepTrainingBalanceInsightDetailViewModel

    public init(insight: InsightItem) {
        _viewModel = StateObject(wrappedValue: SleepTrainingBalanceInsightDetailViewModel(insight: insight))
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                SleepTrainingBalanceInsightCardView(insight: viewModel.insight)
                sleepSection
                loadSection
                interpretationSection
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .navigationTitle(viewModel.title)
        .scrollIndicators(.hidden)
    }
}

private extension SleepTrainingBalanceInsightDetailView {
    var sleepSection: some View {
        sectionCard(title: "Sleep") {
            statRow(title: viewModel.currentWeekLabel, value: viewModel.sleepAverageText, unit: "hr", icon: "bed.double.fill")
            statRow(title: viewModel.previousWeekLabel, value: viewModel.sleepPreviousText, unit: "hr", icon: "moon")
            statRow(title: "Change", value: viewModel.sleepDeltaText, unit: nil, icon: "arrow.up.right")
        }
    }

    var loadSection: some View {
        sectionCard(title: "Training Load") {
            statRow(title: viewModel.currentWeekLabel, value: viewModel.loadAverageText, unit: "min", icon: "flame")
            statRow(title: viewModel.previousWeekLabel, value: viewModel.loadPreviousText, unit: "min", icon: "clock.arrow.circlepath")
            statRow(title: "Change", value: viewModel.loadDeltaText, unit: nil, icon: "arrow.up.right")
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

    func statRow(title: String, value: String, unit: String?, icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.indigo)
                .frame(width: 22, height: 22)
                .background(Color.indigo.opacity(0.15), in: Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                HStack(spacing: 4) {
                    Text(value)
                        .font(.subheadline.weight(.semibold))
                    if let unit {
                        Text(unit)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
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
        SleepTrainingBalanceInsightDetailView(
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
    }
}
#endif
