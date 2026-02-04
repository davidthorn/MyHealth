//
//  CardioFitnessDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct CardioFitnessDetailView: View {
    @StateObject private var viewModel: CardioFitnessDetailViewModel

    public init(service: CardioFitnessDetailServiceProtocol) {
        _viewModel = StateObject(wrappedValue: CardioFitnessDetailViewModel(service: service))
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
                            CardioFitnessSummaryCardView(
                                latest: viewModel.latestReading,
                                averageText: viewModel.averageText,
                                minText: viewModel.minText,
                                maxText: viewModel.maxText,
                                unitText: viewModel.unitText,
                                windowTitle: viewModel.selectedWindow.title,
                                isDayWindow: viewModel.selectedWindow == .day,
                                latestValueText: viewModel.latestReading.map(viewModel.vo2Text) ?? "—",
                                latestDateText: viewModel.latestReading?.endDate.formatted(date: .abbreviated, time: .shortened) ?? "—"
                            )
                        }

                        sectionCard(title: "VO₂ max") {
                            CardioFitnessLineChartView(
                                readings: viewModel.chartReadings(),
                                window: viewModel.selectedWindow
                            )
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Readings")
                                .font(.headline)
                            if viewModel.readings.isEmpty {
                                ContentUnavailableView(
                                    "No Readings",
                                    systemImage: "wind",
                                    description: Text("VO₂ max readings will appear here.")
                                )
                            } else {
                                LazyVStack(spacing: 12) {
                                    ForEach(viewModel.groupedReadings, id: \.date) { group in
                                        let summary = viewModel.daySummary(for: group.date)
                                        CardioFitnessDaySectionView(
                                            title: viewModel.dayTitle(for: group.date),
                                            averageText: summary.average,
                                            minText: summary.min,
                                            maxText: summary.max,
                                            unitText: viewModel.unitText,
                                            readings: group.readings,
                                            valueText: viewModel.vo2Text(for:),
                                            timeText: viewModel.timeText(for:),
                                            level: viewModel.level(for:)
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
                        systemImage: "wind",
                        description: Text("Enable Health access to view VO₂ max data.")
                    )
                    Button("Request Access") {
                        viewModel.requestAuthorization()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Cardio Fitness")
        .task {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
    }
}

private extension CardioFitnessDetailView {
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
        CardioFitnessDetailView(service: AppServices.shared.cardioFitnessDetailService)
    }
}
#endif
