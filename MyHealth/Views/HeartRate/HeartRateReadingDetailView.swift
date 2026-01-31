//
//  HeartRateReadingDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct HeartRateReadingDetailView: View {
    @StateObject private var viewModel: HeartRateReadingDetailViewModel

    public init(service: HeartRateReadingDetailServiceProtocol, id: UUID) {
        _viewModel = StateObject(wrappedValue: HeartRateReadingDetailViewModel(service: service, id: id))
    }

    public var body: some View {
        Group {
            if viewModel.isAuthorized {
                if let reading = viewModel.reading {
                    List {
                        Section("Reading") {
                            LabeledContent("Heart Rate", value: "\(Int(reading.bpm.rounded())) bpm")
                            LabeledContent(
                                "Start",
                                value: reading.startDate.formatted(date: .abbreviated, time: .shortened)
                            )
                            LabeledContent(
                                "End",
                                value: reading.endDate.formatted(date: .abbreviated, time: .shortened)
                            )
                            if let sourceName = reading.sourceName {
                                LabeledContent("Source", value: sourceName)
                            }
                            if let deviceName = reading.deviceName {
                                LabeledContent("Device", value: deviceName)
                            }
                            if let motionContext = reading.motionContext {
                                LabeledContent("Motion", value: motionContext)
                            }
                            if let sensorLocation = reading.sensorLocation {
                                LabeledContent("Sensor", value: sensorLocation)
                            }
                            if let wasUserEntered = reading.wasUserEntered {
                                LabeledContent("User Entered", value: wasUserEntered ? "Yes" : "No")
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                } else {
                    ContentUnavailableView(
                        "Reading Not Found",
                        systemImage: "heart.text.square",
                        description: Text("This heart rate reading is no longer available.")
                    )
                }
            } else {
                VStack(spacing: 12) {
                    ContentUnavailableView(
                        "Health Access Needed",
                        systemImage: "heart.text.square",
                        description: Text("Enable Health access to view heart rate data.")
                    )
                    Button("Request Access") {
                        viewModel.requestAuthorization()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Heart Rate")
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
        HeartRateReadingDetailView(
            service: AppServices.shared.heartRateReadingDetailService,
            id: UUID()
        )
    }
}
#endif
