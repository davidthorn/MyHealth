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
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Today")
                        .font(.headline)
                    Text("Last updated 2 min ago")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(Array(viewModel.summaryCards.enumerated()), id: \.offset) { _, card in
                        NavigationLink(value: viewModel.route(for: card.category)) {
                            MetricSummaryCardView(
                                title: card.category.title,
                                value: card.value,
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

                VStack(alignment: .leading, spacing: 12) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 8)], alignment: .leading, spacing: 8) {
                        ForEach(viewModel.ranges, id: \.self) { range in
                            MetricFilterChipView(
                                title: range,
                                isSelected: viewModel.selectedRange == range
                            ) {
                                viewModel.selectRange(range)
                            }
                        }
                    }

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), spacing: 8)], alignment: .leading, spacing: 8) {
                        ForEach(viewModel.metrics, id: \.self) { metric in
                            MetricFilterChipView(
                                title: metric.title,
                                isSelected: viewModel.selectedMetric == metric
                            ) {
                                viewModel.selectMetric(metric)
                            }
                        }
                    }
                }
                // codex this is the place I want it.
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

                VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(viewModel.selectedMetric.title)
                                .font(.headline)
                            Spacer()
                        NavigationLink("Details", value: viewModel.metricRoute())
                            .font(.subheadline.weight(.semibold))
                    }

                    ZStack {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.secondary.opacity(0.1))
                        VStack(spacing: 8) {
                            Image(systemName: "waveform.path.ecg")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                            Text("Chart Placeholder")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(height: 220)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Key Stats")
                        .font(.headline)
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(Array(viewModel.statItems.enumerated()), id: \.offset) { _, item in
                            MetricStatTileView(title: item.title, value: item.value)
                        }
                    }
                }

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

#if DEBUG
#Preview("Metrics View") {
    MetricsView(service: AppServices.shared.metricsService)
}
#endif
