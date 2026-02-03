//
//  BloodOxygenDotChartView.swift
//  MyHealth
//
//  Created by Codex.
//

import Charts
import Models
import SwiftUI

public struct BloodOxygenDotChartView: View {
    private let readings: [BloodOxygenReading]
    private let window: BloodOxygenWindow

    public init(readings: [BloodOxygenReading], window: BloodOxygenWindow) {
        self.readings = readings
        self.window = window
    }

    public var body: some View {
        Group {
            if readings.isEmpty {
                Text("No blood oxygen readings in this window.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Chart(sortedReadings) { reading in
                    PointMark(
                        x: .value("Time", reading.endDate),
                        y: .value("SpO2", reading.percent)
                    )
                    .symbolSize(28)
                    .foregroundStyle(Color.blue.gradient)
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

private extension BloodOxygenDotChartView {
    var sortedReadings: [BloodOxygenReading] {
        readings.sorted { $0.endDate < $1.endDate }
    }

    var yDomain: ClosedRange<Double> {
        let values = readings.map(\.percent)
        let minValue = values.min() ?? 0
        let maxValue = values.max() ?? 100
        let range = max(maxValue - minValue, 1)
        let padding = range * 0.1
        let lower = max(minValue - padding, 0)
        let upper = min(maxValue + padding, 100)
        return lower...upper
    }

    var xAxisValues: AxisMarkValues {
        switch window {
        case .day:
            return .automatic(desiredCount: 4)
        case .week, .month, .sixMonths, .year:
            return .automatic(desiredCount: 5)
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
        }
    }
}

#if DEBUG
#Preview {
    let readings = [
        BloodOxygenReading(percent: 96.2, startDate: Date().addingTimeInterval(-3600), endDate: Date().addingTimeInterval(-3500)),
        BloodOxygenReading(percent: 97.1, startDate: Date().addingTimeInterval(-2500), endDate: Date().addingTimeInterval(-2400)),
        BloodOxygenReading(percent: 95.6, startDate: Date().addingTimeInterval(-1400), endDate: Date().addingTimeInterval(-1300))
    ]
    return BloodOxygenDotChartView(readings: readings, window: .day)
        .padding()
}
#endif
