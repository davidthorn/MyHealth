//
//  BloodOxygenDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct BloodOxygenDetailView: View {
    @StateObject private var viewModel: BloodOxygenDetailViewModel

    public init(service: BloodOxygenDetailServiceProtocol) {
        _viewModel = StateObject(wrappedValue: BloodOxygenDetailViewModel(service: service))
    }

    public var body: some View {
        Group {
            if viewModel.isAuthorized {
                List {
                    Section {
                        Picker("Window", selection: Binding(
                            get: { viewModel.selectedWindow },
                            set: { viewModel.selectWindow($0) }
                        )) {
                            ForEach(viewModel.windows, id: \.self) { window in
                                Text(window.title).tag(window)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    Section("Summary") {
                        if let latest = viewModel.latestReading {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(viewModel.percentText(for: latest))
                                    .font(.title2.weight(.bold))
                                Text(latest.endDate.formatted(date: .abbreviated, time: .shortened))
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                        } else {
                            Text("No readings yet.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }

                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Average")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(viewModel.averageText)
                                    .font(.subheadline.weight(.semibold))
                            }
                            Spacer()
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Min")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(viewModel.minText)
                                    .font(.subheadline.weight(.semibold))
                            }
                            Spacer()
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Max")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(viewModel.maxText)
                                    .font(.subheadline.weight(.semibold))
                            }
                        }
                    }

                    Section("Chart") {
                        BloodOxygenDotChartView(
                            readings: viewModel.chartReadings(),
                            window: viewModel.selectedWindow
                        )
                    }

                    Section("Readings") {
                        if viewModel.readings.isEmpty {
                            ContentUnavailableView(
                                "No Readings",
                                systemImage: "waveform.path.ecg",
                                description: Text("Blood oxygen readings will appear here.")
                            )
                        } else {
                            ForEach(viewModel.readings.sorted { $0.endDate > $1.endDate }) { reading in
                                HStack {
                                    Text(viewModel.percentText(for: reading))
                                        .font(.subheadline.weight(.semibold))
                                    Spacer()
                                    Text(viewModel.dateText(for: reading))
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            } else {
                VStack(spacing: 12) {
                    ContentUnavailableView(
                        "Health Access Needed",
                        systemImage: "lungs",
                        description: Text("Enable Health access to view blood oxygen data.")
                    )
                    Button("Request Access") {
                        viewModel.requestAuthorization()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Blood Oxygen")
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
        BloodOxygenDetailView(service: AppServices.shared.bloodOxygenDetailService)
    }
}
#endif
