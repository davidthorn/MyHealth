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
        let rows = metricRows
        if !rows.isEmpty {
            Section("Details") {
                ForEach(rows, id: \.title) { row in
                    LabeledContent(row.title, value: row.value)
                }
            }
        }
    }
}

private extension WorkoutDetailMetricsSectionView {
    struct MetricRow {
        let title: String
        let value: String
    }

    var metricRows: [MetricRow] {
        var rows: [MetricRow] = []

        if let durationSeconds = workout.durationSeconds {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .abbreviated
            let value = formatter.string(from: durationSeconds) ?? "—"
            rows.append(MetricRow(title: "Duration", value: value))
        }

        if let distance = workout.totalDistanceMeters {
            let kilometers = distance / 1000
            rows.append(MetricRow(title: "Distance", value: "\(kilometers.formatted(.number.precision(.fractionLength(2)))) km"))
        }

        if let energy = workout.totalEnergyBurnedKilocalories {
            rows.append(MetricRow(title: "Energy", value: "\(energy.formatted(.number.precision(.fractionLength(0)))) kcal"))
        }

        if let elevation = workout.totalElevationGainMeters {
            rows.append(MetricRow(title: "Elevation", value: "\(elevation.formatted(.number.precision(.fractionLength(0)))) m"))
        }

        if let condition = workout.weatherCondition {
            let symbol = workout.weatherConditionSymbolName
            let display = symbol.map { "\($0) \(condition)" } ?? condition
            rows.append(MetricRow(title: "Weather", value: display))
        }

        if let temperature = workout.weatherTemperatureCelsius {
            rows.append(MetricRow(title: "Temperature", value: "\(temperature.formatted(.number.precision(.fractionLength(1)))) °C"))
        }

        if let humidity = workout.weatherHumidityPercent {
            rows.append(MetricRow(title: "Humidity", value: "\(humidity.formatted(.number.precision(.fractionLength(0))))%"))
        }

        if let locationRaw = workout.locationTypeRawValue,
           let location = locationLabel(for: locationRaw) {
            rows.append(MetricRow(title: "Location", value: location))
        }

        if let sourceName = workout.sourceName {
            rows.append(MetricRow(title: "Source", value: sourceName))
        }

        if let deviceName = workout.deviceName {
            rows.append(MetricRow(title: "Device", value: deviceName))
        }

        if let bundleId = workout.sourceBundleIdentifier {
            rows.append(MetricRow(title: "Bundle ID", value: bundleId))
        }

        return rows
    }

    func locationLabel(for rawValue: Int) -> String? {
        switch rawValue {
        case 1: return "Indoor"
        case 2: return "Outdoor"
        case 0: return "Unknown"
        default: return nil
        }
    }

}

#if DEBUG
#Preview {
    List {
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
    }
}
#endif
