//
//  ActivityRingsDayDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct ActivityRingsDayDetailView: View {
    @StateObject private var viewModel: ActivityRingsDayDetailViewModel

    public init(service: ActivityRingsDayDetailServiceProtocol, date: Date) {
        _viewModel = StateObject(wrappedValue: ActivityRingsDayDetailViewModel(service: service, date: date))
    }

    public var body: some View {
        Group {
            if viewModel.isAuthorized {
                if let day = viewModel.day {
                    VStack(spacing: 20) {
                        VStack(spacing: 6) {
                            Text(day.date.formatted(.dateTime.day().month().year()))
                                .font(.headline)
                            Text(day.date.formatted(.dateTime.weekday()))
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }

                        ActivityRingsStackView(
                            moveProgress: day.moveProgress,
                            exerciseProgress: day.exerciseProgress,
                            standProgress: day.standProgress,
                            size: 160
                        )

                        VStack(spacing: 12) {
                            NavigationLink(value: ActivityRingsRoute.metric(.move, day.date)) {
                                ActivityRingsMetricRowView(
                                    title: "Move",
                                    value: "\(Int(day.moveValue.rounded())) kcal",
                                    goal: "Goal \(Int(day.moveGoal.rounded()))"
                                )
                            }
                            .buttonStyle(.plain)

                            NavigationLink(value: ActivityRingsRoute.metric(.exercise, day.date)) {
                                ActivityRingsMetricRowView(
                                    title: "Exercise",
                                    value: "\(Int(day.exerciseMinutes.rounded())) min",
                                    goal: "Goal \(Int(day.exerciseGoal.rounded()))"
                                )
                            }
                            .buttonStyle(.plain)

                            NavigationLink(value: ActivityRingsRoute.metric(.stand, day.date)) {
                                ActivityRingsMetricRowView(
                                    title: "Stand",
                                    value: "\(Int(day.standHours.rounded())) hr",
                                    goal: "Goal \(Int(day.standGoal.rounded()))"
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)

                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 24)
                } else {
                    ContentUnavailableView(
                        "No Activity Rings",
                        systemImage: "figure.run.circle",
                        description: Text("Activity rings will appear after they are fetched.")
                    )
                }
            } else {
                VStack(spacing: 12) {
                    ContentUnavailableView(
                        "Health Access Needed",
                        systemImage: "figure.run.circle",
                        description: Text("Enable Health access to view activity rings.")
                    )
                    Button("Request Access") {
                        viewModel.requestAuthorization()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Activity Rings")
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
        ActivityRingsDayDetailView(
            service: AppServices.shared.activityRingsDayDetailService,
            date: Date()
        )
    }
}
#endif
