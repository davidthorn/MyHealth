//
//  SleepReadingDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct SleepReadingDetailView: View {
    @StateObject private var viewModel: SleepReadingDetailViewModel

    public init(service: SleepReadingDetailServiceProtocol, date: Date) {
        _viewModel = StateObject(wrappedValue: SleepReadingDetailViewModel(service: service, date: date))
    }

    public var body: some View {
        Group {
            if viewModel.isAuthorized {
                if let day = viewModel.day {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            SleepSummaryHeaderView(
                                title: viewModel.formattedDateText(),
                                durationText: viewModel.totalDurationText
                            )

                            if !viewModel.chartEntries.isEmpty {
                                SleepTimelineChartView(
                                    entries: viewModel.chartEntries,
                                    colorProvider: viewModel.stageColor(for:)
                                )
                            }

                            if !viewModel.categorySummaries.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Stages")
                                        .font(.headline)
                                    LazyVGrid(columns: [
                                        GridItem(.flexible(), spacing: 12),
                                        GridItem(.flexible(), spacing: 12)
                                    ], spacing: 12) {
                                        ForEach(viewModel.categorySummaries) { summary in
                                            SleepStageMetricChipView(
                                                summary: summary,
                                                durationText: viewModel.formattedDuration(summary.durationSeconds)
                                            )
                                        }
                                    }
                                }
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .fill(Color(UIColor.secondarySystemBackground))
                                )
                            }

                            VStack(alignment: .leading, spacing: 12) {
                                Text("Entries")
                                    .font(.headline)
                                if viewModel.entries.isEmpty {
                                    ContentUnavailableView(
                                        "No Sleep Entries",
                                        systemImage: "bed.double",
                                        description: Text("Entries will appear once recorded.")
                                    )
                                } else {
                                    LazyVStack(spacing: 12) {
                                        ForEach(viewModel.entries) { entry in
                                            SleepEntryDetailCardView(entry: entry)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                    }
                    .scrollIndicators(.hidden)
                } else {
                    ContentUnavailableView(
                        "No Sleep Data",
                        systemImage: "bed.double",
                        description: Text("Sleep data will appear after it is fetched.")
                    )
                }
            } else {
                VStack(spacing: 12) {
                    ContentUnavailableView(
                        "Health Access Needed",
                        systemImage: "bed.double",
                        description: Text("Enable Health access to view sleep data.")
                    )
                    Button("Request Access") {
                        viewModel.requestAuthorization()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Sleep Detail")
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
        SleepReadingDetailView(service: AppServices.shared.sleepReadingDetailService, date: Date())
    }
}
#endif
