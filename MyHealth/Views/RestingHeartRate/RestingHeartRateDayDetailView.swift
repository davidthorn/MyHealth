//
//  RestingHeartRateDayDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct RestingHeartRateDayDetailView: View {
    @StateObject private var viewModel: RestingHeartRateDayDetailViewModel

    public init(service: RestingHeartRateDayDetailServiceProtocol, date: Date) {
        _viewModel = StateObject(wrappedValue: RestingHeartRateDayDetailViewModel(service: service, date: date))
    }

    public var body: some View {
        Group {
            if viewModel.isAuthorized {
                if viewModel.readings.isEmpty {
                    ContentUnavailableView(
                        "No Resting HR Samples",
                        systemImage: "heart",
                        description: Text("No resting heart rate samples were recorded for this day.")
                    )
                } else {
                    List {
                        Section(viewModel.date.formatted(.dateTime.day().month().year())) {
                            ForEach(viewModel.readings) { reading in
                                VStack(spacing: 12) {
                                    RestingHeartRateReadingRowView(reading: reading)
                                    RestingHeartRateRangeChartView(points: viewModel.rangePoints(for: reading))
                                }
                                .onAppear {
                                    viewModel.loadRange(for: reading)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            } else {
                VStack(spacing: 12) {
                    ContentUnavailableView(
                        "Health Access Needed",
                        systemImage: "heart",
                        description: Text("Enable Health access to view resting heart rate.")
                    )
                    Button("Request Access") {
                        viewModel.requestAuthorization()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Resting HR")
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
        RestingHeartRateDayDetailView(service: AppServices.shared.restingHeartRateDayDetailService, date: Date())
    }
}
#endif
