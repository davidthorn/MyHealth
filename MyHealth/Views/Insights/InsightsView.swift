//
//  InsightsView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct InsightsView: View {
    @StateObject private var viewModel: InsightsViewModel

    public init(service: InsightsServiceProtocol) {
        _viewModel = StateObject(wrappedValue: InsightsViewModel(service: service))
    }

    public var body: some View {
        Group {
            if viewModel.isAuthorized {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        header

                        if viewModel.insights.isEmpty {
                            ContentUnavailableView(
                                "No Insights Yet",
                                systemImage: "sparkles",
                                description: Text("Insights will appear once activity data is available.")
                            )
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.insights) { insight in
                                    NavigationLink(value: InsightsRoute(insight: insight)) {
                                        if insight.type == .activityHighlights {
                                            ActivityHighlightsInsightCardView(insight: insight)
                                        } else {
                                            InsightCardView(insight: insight)
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                }
                .scrollIndicators(.hidden)
            } else {
                VStack(spacing: 12) {
                    ContentUnavailableView(
                        "Health Access Needed",
                        systemImage: "sparkles",
                        description: Text("Enable Health access to see your activity insights.")
                    )
                    Button("Request Access") {
                        viewModel.requestAuthorization()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
            }
        }
        .task {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
    }
}

private extension InsightsView {
    var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Activity patterns from the last 7 days.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        InsightsView(service: AppServices.shared.insightsService)
    }
}
#endif
