//
//  ActivityRingsMetricDayDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct ActivityRingsMetricDayDetailView: View {
    @StateObject private var viewModel: ActivityRingsMetricDayDetailViewModel

    public init(
        service: ActivityRingsMetricDayDetailServiceProtocol,
        metric: ActivityRingsMetric,
        date: Date
    ) {
        _viewModel = StateObject(
            wrappedValue: ActivityRingsMetricDayDetailViewModel(
                service: service,
                metric: metric,
                date: date
            )
        )
    }

    public var body: some View {
        Group {
            if viewModel.isAuthorized {
                if viewModel.day != nil {
                    VStack(spacing: 20) {
                        ActivityRingView(
                            progress: viewModel.progress,
                            color: viewModel.metricColor,
                            lineWidth: 18
                        )
                        .frame(width: 160, height: 160)

                        VStack(spacing: 10) {
                            Text(viewModel.metric.title)
                                .font(.title2.weight(.bold))
                            Text(viewModel.dateTitle)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }

                        ActivityRingsMetricRowView(
                            title: "Today",
                            value: viewModel.valueText,
                            goal: viewModel.goalText
                        )
                        .padding(.horizontal)

                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 24)
                } else {
                    ContentUnavailableView(
                        "No \(viewModel.metric.title) Data",
                        systemImage: viewModel.metric.systemImage,
                        description: Text("Activity data will appear after it is fetched.")
                    )
                }
            } else {
                VStack(spacing: 12) {
                    ContentUnavailableView(
                        "Health Access Needed",
                        systemImage: viewModel.metric.systemImage,
                        description: Text("Enable Health access to view activity rings.")
                    )
                    Button("Request Access") {
                        viewModel.requestAuthorization()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(viewModel.metric.title)
        .task {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        ActivityRingsMetricDayDetailView(
            service: AppServices.shared.activityRingsMetricDayDetailService,
            metric: .move,
            date: Date()
        )
    }
}
#endif
