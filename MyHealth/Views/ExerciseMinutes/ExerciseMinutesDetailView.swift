//
//  ExerciseMinutesDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct ExerciseMinutesDetailView: View {
    @StateObject private var viewModel: ExerciseMinutesDetailViewModel

    public init(service: ExerciseMinutesDetailServiceProtocol) {
        _viewModel = StateObject(wrappedValue: ExerciseMinutesDetailViewModel(service: service))
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

                    Section(viewModel.selectedWindow == .day ? "Today" : "Average") {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(viewModel.selectedWindow == .day ? viewModel.totalText : viewModel.averageText)
                                .font(.title2.weight(.bold))
                            Text(viewModel.selectedWindow == .day ? "Exercise minutes today" : "Average per day")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Section("Exercise Minutes") {
                        ExerciseMinutesBarChartView(days: viewModel.sortedDays, window: viewModel.selectedWindow)
                    }

                    Section("Daily Totals") {
                        if viewModel.sortedDays.isEmpty {
                            ContentUnavailableView(
                                "No Exercise Minutes",
                                systemImage: "figure.run",
                                description: Text("Exercise minutes will appear once recorded.")
                            )
                        } else {
                            ForEach(viewModel.sortedDays.reversed()) { day in
                                ExerciseMinutesDayRowView(day: day)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            } else {
                VStack(spacing: 12) {
                    ContentUnavailableView(
                        "Health Access Needed",
                        systemImage: "figure.run",
                        description: Text("Enable Health access to view exercise minutes.")
                    )
                    Button("Request Access") {
                        viewModel.requestAuthorization()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Exercise Minutes")
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
        ExerciseMinutesDetailView(service: AppServices.shared.exerciseMinutesDetailService)
    }
}
#endif
