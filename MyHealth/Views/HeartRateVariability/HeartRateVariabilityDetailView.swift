//
//  HeartRateVariabilityDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct HeartRateVariabilityDetailView: View {
    @StateObject private var viewModel: HeartRateVariabilityDetailViewModel

    public init(service: HeartRateVariabilityDetailServiceProtocol) {
        _viewModel = StateObject(wrappedValue: HeartRateVariabilityDetailViewModel(service: service))
    }

    public var body: some View {
        Group {
            if viewModel.isAuthorized {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Picker("Window", selection: Binding(
                            get: { viewModel.selectedWindow },
                            set: { viewModel.selectWindow($0) }
                        )) {
                            ForEach(viewModel.windows, id: \.self) { window in
                                Text(window.title).tag(window)
                            }
                        }
                        .pickerStyle(.segmented)

                        sectionCard(title: "Summary") {
                            HeartRateVariabilitySummaryCardView(
                                latest: viewModel.latestReading,
                                averageText: viewModel.averageText,
                                minText: viewModel.minText,
                                maxText: viewModel.maxText,
                                windowTitle: viewModel.selectedWindow.title,
                                isDayWindow: viewModel.selectedWindow == .day,
                                latestValueText: viewModel.latestReading.map(viewModel.millisecondsText) ?? "—",
                                latestDateText: viewModel.latestReading?.endDate.formatted(date: .abbreviated, time: .shortened) ?? "—"
                            )
                        }

                        sectionCard(title: "HRV") {
                            HeartRateVariabilityLineChartView(
                                readings: viewModel.chartReadings(),
                                window: viewModel.selectedWindow
                            )
                        }

                        LazyVStack(alignment: .leading, spacing: 12) {
                            Text("Readings")
                                .font(.headline)
                            if viewModel.readings.isEmpty {
                                ContentUnavailableView(
                                    "No Readings",
                                    systemImage: "waveform.path.ecg",
                                    description: Text("HRV readings will appear here.")
                                )
                            } else {
                                LazyVStack(spacing: 12) {
                                    ForEach(viewModel.groupedReadings, id: \.date) { group in
                                        HeartRateVariabilityDaySectionView(
                                            title: viewModel.dayTitle(for: group.date),
                                            summary: viewModel.daySummary(for: group.date),
                                            readings: group.readings,
                                            status: viewModel.status(for:),
                                            timeText: viewModel.timeText(for:),
                                            valueText: viewModel.millisecondsText(for:)
                                        )
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
                VStack(spacing: 12) {
                    ContentUnavailableView(
                        "Health Access Needed",
                        systemImage: "waveform.path.ecg",
                        description: Text("Enable Health access to view HRV data.")
                    )
                    Button("Request Access") {
                        viewModel.requestAuthorization()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("HRV")
        .task {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
    }
}

private extension HeartRateVariabilityDetailView {
    func sectionCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content()
        }
        .padding(14)
        .background(Color(UIColor.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        HeartRateVariabilityDetailView(service: AppServices.shared.heartRateVariabilityDetailService)
    }
}
#endif
