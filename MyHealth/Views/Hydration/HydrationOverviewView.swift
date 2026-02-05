//
//  HydrationOverviewView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct HydrationOverviewView: View {
    @StateObject private var viewModel: HydrationOverviewViewModel
    private let entryService: HydrationEntryServiceProtocol

    public init(
        service: HydrationOverviewServiceProtocol,
        entryService: HydrationEntryServiceProtocol
    ) {
        _viewModel = StateObject(wrappedValue: HydrationOverviewViewModel(service: service))
        self.entryService = entryService
    }

    public var body: some View {
        Group {
            if viewModel.isAuthorized {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        header
                        metricsSection
                        windowPicker
                        samplesSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                }
                .scrollIndicators(.hidden)
            } else {
                VStack(spacing: 12) {
                    ContentUnavailableView(
                        "Health Access Needed",
                        systemImage: "drop.fill",
                        description: Text("Enable Health access to view hydration data.")
                    )
                    Button("Request Access") {
                        viewModel.start()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Hydration")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.isAddPresented = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $viewModel.isAddPresented, onDismiss: viewModel.refresh) {
            HydrationAddEntryView(service: entryService)
        }
        .task {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
    }
}

private extension HydrationOverviewView {
    var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Hydration")
                .font(.title2.weight(.bold))
            Text("Track your fluid intake for today and over time.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    var metricsSection: some View {
        HStack(spacing: 12) {
            HydrationMetricCardView(
                title: "Today",
                value: viewModel.todayTotalText,
                icon: "drop.fill",
                tint: .blue
            )
            HydrationMetricCardView(
                title: "\(viewModel.window.title) Avg",
                value: viewModel.windowAverageText,
                icon: "chart.bar.fill",
                tint: .teal
            )
        }
    }

    var windowPicker: some View {
        Picker("Window", selection: Binding(
            get: { viewModel.window },
            set: { viewModel.selectWindow($0) }
        )) {
            ForEach(HydrationWindow.allCases) { window in
                Text(window.title).tag(window)
            }
        }
        .pickerStyle(.segmented)
    }

    var samplesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Entries")
                .font(.headline)
            if viewModel.samples.isEmpty {
                ContentUnavailableView(
                    "No Hydration Entries",
                    systemImage: "drop",
                    description: Text("Add water intake to see it here.")
                )
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.samples) { sample in
                        HydrationSampleRowView(sample: sample)
                    }
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        HydrationOverviewView(
            service: AppServices.shared.hydrationService,
            entryService: AppServices.shared.hydrationEntryService
        )
    }
}
#endif
