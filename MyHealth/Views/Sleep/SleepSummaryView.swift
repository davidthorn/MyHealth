//
//  SleepSummaryView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct SleepSummaryView: View {
    @StateObject private var viewModel: SleepSummaryViewModel
    @StateObject private var entriesViewModel: SleepEntriesViewModel
    @State private var isAddPresented: Bool
    private let entryService: SleepEntryServiceProtocol

    public init(
        service: SleepSummaryServiceProtocol,
        entryService: SleepEntryServiceProtocol
    ) {
        _viewModel = StateObject(wrappedValue: SleepSummaryViewModel(service: service))
        _entriesViewModel = StateObject(wrappedValue: SleepEntriesViewModel(service: entryService))
        _isAddPresented = State(initialValue: false)
        self.entryService = entryService
    }

    private func formattedDuration(_ seconds: TimeInterval) -> String {
        let totalMinutes = Int(seconds / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }

    public var body: some View {
        Group {
            if viewModel.isAuthorized {
                if let summary = viewModel.summary {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Sleep Overview")
                                    .font(.title3.weight(.semibold))
                                Text("Your recent sleep summary and entries.")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }

                            VStack(alignment: .leading, spacing: 12) {
                                Text("Latest")
                                    .font(.headline)
                                if let latest = summary.latest {
                                    NavigationLink(value: SleepRoute.reading(latest.date)) {
                                        SleepLatestCardView(
                                            day: latest,
                                            formattedDuration: formattedDuration(latest.durationSeconds)
                                        )
                                    }
                                    .buttonStyle(.plain)
                                } else {
                                    ContentUnavailableView(
                                        "No Sleep Yet",
                                        systemImage: "bed.double",
                                        description: Text("Sleep data will appear once recorded.")
                                    )
                                }
                            }

                            VStack(alignment: .leading, spacing: 12) {
                                Text("Recent Nights")
                                    .font(.headline)
                                Text("Your latest sleep sessions at a glance.")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                let recentNights = summary.previous.filter { $0.durationSeconds > 0 }
                                if recentNights.isEmpty {
                                    ContentUnavailableView(
                                        "No Tracked Sleep",
                                        systemImage: "bed.double",
                                        description: Text("Recent nights were not recorded. Wear your watch or track sleep to see it here.")
                                    )
                                } else {
                                    LazyVStack(spacing: 10) {
                                        ForEach(recentNights.prefix(7)) { day in
                                            NavigationLink(value: SleepRoute.reading(day.date)) {
                                                SleepRecentNightCardView(
                                                    day: day,
                                                    formattedDuration: formattedDuration(day.durationSeconds)
                                                )
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                }
                            }

                            VStack(alignment: .leading, spacing: 12) {
                                Text("Entries")
                                    .font(.headline)
                                Text("Detailed stages and timing from each sleep segment.")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                if entriesViewModel.entries.isEmpty {
                                    ContentUnavailableView(
                                        "No Sleep Entries",
                                        systemImage: "bed.double",
                                        description: Text("Add a sleep entry to track details.")
                                    )
                                } else {
                                    LazyVStack(spacing: 12) {
                                        ForEach(entriesViewModel.entries.prefix(10)) { entry in
                                            NavigationLink(value: SleepRoute.reading(entry.startDate)) {
                                                SleepEntryRowView(entry: entry)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                }
                            }

                            NavigationLink(value: SleepRoute.detail) {
                                Text("View All Sleep")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                                            .fill(Color(UIColor.secondarySystemBackground))
                                    )
                            }
                            .buttonStyle(.plain)
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
        .navigationTitle("Sleep")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isAddPresented = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
                .accessibilityLabel("Add Sleep Entry")
            }
        }
        .sheet(isPresented: $isAddPresented, onDismiss: {
            viewModel.refresh()
            entriesViewModel.refresh()
        }) {
            SleepAddEntryView(service: entryService)
        }
        .task {
            viewModel.start()
            entriesViewModel.start()
        }
        .onDisappear {
            viewModel.stop()
            entriesViewModel.stop()
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        SleepSummaryView(
            service: AppServices.shared.sleepSummaryService,
            entryService: AppServices.shared.sleepEntryService
        )
    }
}
#endif
