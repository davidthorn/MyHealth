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
                if let day = viewModel.day {
                    List {
                        Section("Sleep") {
                            LabeledContent("Duration", value: formattedDuration(day.durationSeconds))
                            LabeledContent(
                                "Date",
                                value: day.date.formatted(date: .abbreviated, time: .omitted)
                            )
                        }
                    }
                    .listStyle(.insetGrouped)
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
