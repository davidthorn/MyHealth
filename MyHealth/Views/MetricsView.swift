//
//  MetricsView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct MetricsView: View {
    @StateObject private var viewModel: MetricsViewModel

    public init(service: MetricsServiceProtocol) {
        _viewModel = StateObject(wrappedValue: MetricsViewModel(service: service))
    }

    public var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 24) {
                headerSection
                highlightsSection
                restingHeartRateSection
                nutritionSection
                allMetricsSection
                keyStatsSection
                insightsSection
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .scrollIndicators(.hidden)
        .task {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
    }
}

private extension MetricsView {
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Today")
                .font(.title2.weight(.bold))
            if let lastUpdated = viewModel.lastUpdated {
                Text("Last updated \(lastUpdated, format: .relative(presentation: .named))")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }

    var highlightsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Highlights")
                .font(.headline)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(Array(viewModel.highlightCards.enumerated()), id: \.offset) { _, card in
                    NavigationLink(value: viewModel.route(for: card.category)) {
                        MetricSummaryCardView(
                            category: card.category,
                            value: card.value,
                            unit: card.unit,
                            subtitle: card.subtitle,
                            trend: card.trend
                        )
                    }
                    .buttonStyle(.plain)
                    .simultaneousGesture(TapGesture().onEnded {
                        viewModel.selectMetric(card.category)
                    })
                }
            }
        }
    }

    var restingHeartRateSection: some View {
        Group {
            if let latest = viewModel.restingHeartRateSummary?.latest {
                MetricsRestingHeartRateLatestCardView(
                    latest: latest,
                    chartPoints: viewModel.latestRestingHeartRatePoints()
                )
            } else {
                ContentUnavailableView(
                    "No Resting Heart Rate",
                    systemImage: "heart",
                    description: Text("Resting heart rate will appear once recorded.")
                )
                .frame(maxWidth: .infinity)
            }
        }
    }

    var nutritionSection: some View {
        Group {
            if let nutritionSummary = viewModel.nutritionSummary {
                MetricsNutritionSummaryCardView(
                    summary: nutritionSummary,
                    selectedWindow: Binding(
                        get: { viewModel.nutritionWindow },
                        set: { viewModel.selectNutritionWindow($0) }
                    ),
                    windows: viewModel.nutritionWindows
                )
            }
        }
    }

    var allMetricsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All Metrics")
                .font(.headline)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(Array(viewModel.otherCards.enumerated()), id: \.offset) { _, card in
                    NavigationLink(value: viewModel.route(for: card.category)) {
                        MetricSummaryCardView(
                            category: card.category,
                            value: card.value,
                            unit: card.unit,
                            subtitle: card.subtitle,
                            trend: card.trend
                        )
                    }
                    .buttonStyle(.plain)
                    .simultaneousGesture(TapGesture().onEnded {
                        viewModel.selectMetric(card.category)
                    })
                }
            }
        }
    }

    var keyStatsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Key Stats")
                .font(.headline)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(Array(viewModel.statItems.enumerated()), id: \.offset) { _, item in
                    MetricStatTileView(title: item.title, value: item.value)
                }
            }
        }
    }

    var insightsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Insights")
                .font(.headline)
            VStack(spacing: 12) {
                ForEach(Array(viewModel.insights.enumerated()), id: \.offset) { _, insight in
                    MetricsInsightCardView(title: insight.title, detail: insight.detail)
                }
            }
        }
    }

}

#if DEBUG
#Preview("Metrics View") {
    MetricsView(service: AppServices.shared.metricsService)
}
#endif
