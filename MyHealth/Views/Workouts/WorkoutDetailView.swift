//
//  WorkoutDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct WorkoutDetailView: View {
    @StateObject private var viewModel: WorkoutDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isRouteFullScreenPresented: Bool = false
    @State private var isDeleteProgressPresented: Bool = false
    @State private var shouldDeleteAfterProgress: Bool = false
    @State private var isDeleteErrorPresented: Bool = false

    public init(service: WorkoutDetailServiceProtocol, id: UUID) {
        _viewModel = StateObject(wrappedValue: WorkoutDetailViewModel(service: service, id: id))
    }

    public var body: some View {
        Group {
            if let workout = viewModel.workout {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        WorkoutDetailSummarySectionView(workout: workout, durationText: viewModel.durationText)
                        if !viewModel.canDelete {
                            WorkoutDetailCardView {
                                VStack(alignment: .leading, spacing: 8) {
                                    Label("Read-only workout", systemImage: "lock.fill")
                                        .font(.footnote.weight(.semibold))
                                        .foregroundStyle(.secondary)
                                    Text("This workout was created by another app and can’t be deleted here.")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        WorkoutDetailTimingSectionView(workout: workout, durationText: viewModel.durationText)
                        WorkoutDetailMetricsSectionView(workout: workout)
                        if !viewModel.routePoints.isEmpty {
                            WorkoutDetailRouteSectionView(
                                points: viewModel.routePoints,
                                onFullScreen: { isRouteFullScreenPresented = true }
                            )
                            WorkoutDetailSplitsSectionView(
                                splits: viewModel.splits,
                                durationText: viewModel.splitDurationText,
                                paceText: viewModel.paceText,
                                heartRateText: viewModel.heartRateText
                            )
                            WorkoutDetailHeartRateSectionView(points: viewModel.workoutHeartRatePoints)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .background(Color(UIColor.systemGroupedBackground))
            } else {
                ContentUnavailableView("Workout Not Found", systemImage: "figure.run", description: Text("This workout is no longer available."))
            }
        }
        .navigationTitle("Workout")
        .toolbar {
            if viewModel.canDelete {
                Button(role: .destructive) {
                    viewModel.requestDelete()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .task {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
        .alert("Delete Workout?", isPresented: $viewModel.isDeleteAlertPresented) {
            Button("Delete", role: .destructive) {
                viewModel.isDeleteAlertPresented = false
                shouldDeleteAfterProgress = true
                isDeleteProgressPresented = true
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
        .sheet(isPresented: $isDeleteProgressPresented) {
            VStack(spacing: 16) {
                ProgressView()
                Text("Deleting workout…")
                    .font(.headline)
            }
            .padding()
            .presentationDetents([.height(160)])
            .task {
                guard shouldDeleteAfterProgress else { return }
                shouldDeleteAfterProgress = false
                do {
                    try await viewModel.delete()
                    await MainActor.run {
                        isDeleteProgressPresented = false
                        dismiss()
                    }
                } catch {
                    await MainActor.run {
                        viewModel.errorMessage = error.localizedDescription
                        isDeleteProgressPresented = false
                        isDeleteErrorPresented = true
                    }
                }
            }
        }
        .alert("Unable to Delete", isPresented: $isDeleteErrorPresented) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .onChange(of: isDeleteErrorPresented) { _, isPresented in
            if !isPresented {
                viewModel.errorMessage = nil
            }
        }
        .sheet(isPresented: $isRouteFullScreenPresented) {
            WorkoutRouteFullScreenView(points: viewModel.routePoints)
        }
    }
}

#if DEBUG
#Preview {
    let id = UUID()
    let workout = Workout(
        id: id,
        title: "Evening Run",
        type: .running,
        startedAt: Date().addingTimeInterval(-3200),
        endedAt: Date(),
        sourceBundleIdentifier: Bundle.main.bundleIdentifier ?? "com.example.myhealth",
        sourceName: "MyHealth",
        deviceName: "iPhone",
        activityTypeRawValue: 37,
        locationTypeRawValue: 2,
        durationSeconds: 3200,
        totalDistanceMeters: 6800,
        totalEnergyBurnedKilocalories: 520,
        totalElevationGainMeters: 64,
        weatherTemperatureCelsius: 18.2,
        weatherHumidityPercent: 55,
        weatherCondition: "Partly Cloudy",
        weatherConditionSymbolName: "cloud.sun.fill"
    )
    let points = [
        WorkoutRoutePoint(latitude: 37.332, longitude: -122.031, timestamp: Date().addingTimeInterval(-3000), horizontalAccuracy: nil),
        WorkoutRoutePoint(latitude: 37.333, longitude: -122.029, timestamp: Date().addingTimeInterval(-2600), horizontalAccuracy: nil),
        WorkoutRoutePoint(latitude: 37.334, longitude: -122.028, timestamp: Date().addingTimeInterval(-2200), horizontalAccuracy: nil),
        WorkoutRoutePoint(latitude: 37.336, longitude: -122.026, timestamp: Date().addingTimeInterval(-1800), horizontalAccuracy: nil),
        WorkoutRoutePoint(latitude: 37.338, longitude: -122.024, timestamp: Date().addingTimeInterval(-1400), horizontalAccuracy: nil),
        WorkoutRoutePoint(latitude: 37.339, longitude: -122.022, timestamp: Date().addingTimeInterval(-1000), horizontalAccuracy: nil)
    ]
    let heartRates = [
        HeartRateReading(bpm: 128, date: Date().addingTimeInterval(-2500), startDate: Date().addingTimeInterval(-2505), endDate: Date().addingTimeInterval(-2495)),
        HeartRateReading(bpm: 142, date: Date().addingTimeInterval(-2000), startDate: Date().addingTimeInterval(-2005), endDate: Date().addingTimeInterval(-1995)),
        HeartRateReading(bpm: 151, date: Date().addingTimeInterval(-1500), startDate: Date().addingTimeInterval(-1505), endDate: Date().addingTimeInterval(-1495)),
        HeartRateReading(bpm: 138, date: Date().addingTimeInterval(-1000), startDate: Date().addingTimeInterval(-1005), endDate: Date().addingTimeInterval(-995))
    ]
    let service = WorkoutDetailPreviewService(
        workout: workout,
        routePoints: points,
        heartRateReadings: heartRates
    )

    return NavigationStack {
        WorkoutDetailView(service: service, id: id)
    }
}
#endif
