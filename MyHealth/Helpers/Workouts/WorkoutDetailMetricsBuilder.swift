//
//  WorkoutDetailMetricsBuilder.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct WorkoutDetailMetricsBuilder: Sendable {
    public struct MetricRow: Hashable, Sendable {
        public let title: String
        public let value: String
        public let symbolName: String?

        public init(title: String, value: String, symbolName: String? = nil) {
            self.title = title
            self.value = value
            self.symbolName = symbolName
        }
    }

    public init() {}

    public func rows(for workout: Workout) -> [MetricRow] {
        var rows: [MetricRow] = []

        if let durationSeconds = workout.durationSeconds {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .abbreviated
            let value = formatter.string(from: durationSeconds) ?? "—"
            rows.append(MetricRow(title: "Duration", value: value, symbolName: "timer"))
        }

        if let distance = workout.totalDistanceMeters {
            let kilometers = distance / 1000
            rows.append(MetricRow(
                title: "Distance",
                value: "\(kilometers.formatted(.number.precision(.fractionLength(2)))) km",
                symbolName: "map"
            ))
        }

        if let energy = workout.totalEnergyBurnedKilocalories {
            rows.append(MetricRow(
                title: "Energy",
                value: "\(energy.formatted(.number.precision(.fractionLength(0)))) kcal",
                symbolName: "flame"
            ))
        }

        if let elevation = workout.totalElevationGainMeters {
            rows.append(MetricRow(
                title: "Elevation",
                value: "\(elevation.formatted(.number.precision(.fractionLength(0)))) m",
                symbolName: "mountain.2"
            ))
        }

        if let condition = workout.weatherCondition {
            rows.append(MetricRow(
                title: "Weather",
                value: condition,
                symbolName: workout.weatherConditionSymbolName
            ))
        }

        if let temperature = workout.weatherTemperatureCelsius {
            rows.append(MetricRow(
                title: "Temperature",
                value: "\(temperature.formatted(.number.precision(.fractionLength(1)))) °C",
                symbolName: "thermometer"
            ))
        }

        if let humidity = workout.weatherHumidityPercent {
            rows.append(MetricRow(
                title: "Humidity",
                value: "\(humidity.formatted(.number.precision(.fractionLength(0))))%",
                symbolName: "drop"
            ))
        }

        if let location = locationLabel(for: workout.locationTypeRawValue) {
            rows.append(MetricRow(title: "Location", value: location, symbolName: "location"))
        }

        if let sourceName = workout.sourceName {
            rows.append(MetricRow(title: "Source", value: sourceName, symbolName: "app"))
        }

        if let deviceName = workout.deviceName {
            rows.append(MetricRow(title: "Device", value: deviceName, symbolName: "iphone"))
        }

        if let bundleId = workout.sourceBundleIdentifier {
            rows.append(MetricRow(title: "Bundle ID", value: bundleId, symbolName: "link"))
        }

        return rows
    }

    private func locationLabel(for rawValue: Int?) -> String? {
        switch rawValue {
        case 1: return "Indoor"
        case 2: return "Outdoor"
        case 0: return "Unknown"
        default: return nil
        }
    }
}
