//
//  WorkoutDetailMetricsSectionView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct WorkoutDetailMetricsSectionView: View {
    private let workout: Workout

    public init(workout: Workout) {
        self.workout = workout
    }

    public var body: some View {
        let rows = WorkoutDetailMetricsBuilder().rows(for: workout)
        if rows.isEmpty {
            EmptyView()
        } else {
            let sourceTitles: Set<String> = ["Source", "Device", "Bundle ID"]
            let primaryRows = rows.filter { !sourceTitles.contains($0.title) }
            let sourceRows = rows.filter { sourceTitles.contains($0.title) }

            VStack(spacing: 16) {
                if !primaryRows.isEmpty {
                    WorkoutDetailCardView(title: "Details") {
                        let columns = [GridItem(.flexible()), GridItem(.flexible())]
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(primaryRows, id: \.title) { row in
                                WorkoutDetailMetricRowView(
                                    title: row.title,
                                    value: row.value,
                                    symbolName: row.symbolName,
                                    accentColor: workout.type.accentColor
                                )
                            }
                        }
                    }
                }

                if !sourceRows.isEmpty {
                    WorkoutDetailCardView(title: "Source") {
                        VStack(spacing: 10) {
                            ForEach(sourceRows, id: \.title) { row in
                                WorkoutDetailKeyValueRowView(title: row.title, value: row.value)
                            }
                        }
                    }
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    ScrollView {
        WorkoutDetailMetricsSectionView(
            workout: Workout(
                id: UUID(),
                title: "Run",
                type: .running,
                startedAt: Date().addingTimeInterval(-1800),
                endedAt: Date(),
                sourceBundleIdentifier: "com.example.myhealth",
                sourceName: "MyHealth",
                deviceName: "iPhone",
                activityTypeRawValue: 37,
                locationTypeRawValue: 2,
                durationSeconds: 1800,
                totalDistanceMeters: 4200,
                totalEnergyBurnedKilocalories: 320,
                totalElevationGainMeters: 45,
                weatherTemperatureCelsius: 16.4,
                weatherHumidityPercent: 62,
                weatherCondition: "Partly Cloudy",
                weatherConditionSymbolName: "cloud.sun.fill"
            )
        )
        .padding()
    }
}
#endif
