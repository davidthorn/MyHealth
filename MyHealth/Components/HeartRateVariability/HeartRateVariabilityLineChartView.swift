//
//  HeartRateVariabilityLineChartView.swift
//  MyHealth
//
//  Created by Codex.
//

import Charts
import Models
import SwiftUI

public struct HeartRateVariabilityLineChartView: View {
    private let readings: [HeartRateVariabilityReading]
    private let window: HeartRateVariabilityWindow

    public init(readings: [HeartRateVariabilityReading], window: HeartRateVariabilityWindow) {
        self.readings = readings
        self.window = window
    }

    public var body: some View {
        Group {
            if readings.isEmpty {
                Text("No HRV readings in this window.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Chart(sortedReadings) { reading in
                    LineMark(
                        x: .value("Time", reading.endDate),
                        y: .value("HRV", reading.milliseconds)
                    )
                    .foregroundStyle(Color.purple.gradient)
                }
                .chartYScale(domain: yDomain)
                .chartXAxis {
                    AxisMarks(values: xAxisValues) { _ in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: xAxisFormat, centered: true)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading, values: .automatic(desiredCount: 3))
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 4)
    }
}

private extension HeartRateVariabilityLineChartView {
    var sortedReadings: [HeartRateVariabilityReading] {
        readings.sorted { $0.endDate < $1.endDate }
    }

    var yDomain: ClosedRange<Double> {
        let values = readings.map(\.milliseconds)
        let minValue = values.min() ?? 0
        let maxValue = values.max() ?? 1
        let padding = max((maxValue - minValue) * 0.1, maxValue * 0.1)
        let lower = max(minValue - padding, 0)
        let upper = maxValue + padding
        return lower...upper
    }

    var xAxisValues: AxisMarkValues {
        switch window {
        case .day:
            return .automatic(desiredCount: 4)
        case .week, .month, .sixMonths, .year:
            return .automatic(desiredCount: 5)
        @unknown default:
            fatalError()
        }
    }

    var xAxisFormat: Date.FormatStyle {
        switch window {
        case .day:
            return .dateTime.hour().minute()
        case .week:
            return .dateTime.weekday(.abbreviated)
        case .month, .sixMonths, .year:
            return .dateTime.month().day()
        @unknown default:
            fatalError()
        }
    }
}

#if DEBUG
#Preview {
    let readings = [
        HeartRateVariabilityReading(milliseconds: 42, startDate: Date().addingTimeInterval(-3600), endDate: Date().addingTimeInterval(-3500)),
        HeartRateVariabilityReading(milliseconds: 58, startDate: Date().addingTimeInterval(-2500), endDate: Date().addingTimeInterval(-2400)),
        HeartRateVariabilityReading(milliseconds: 35, startDate: Date().addingTimeInterval(-1400), endDate: Date().addingTimeInterval(-1300))
    ]
    return HeartRateVariabilityLineChartView(readings: readings, window: .day)
        .padding()
}
#endif
