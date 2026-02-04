//
//  CardioFitnessLineChartView.swift
//  MyHealth
//
//  Created by Codex.
//

import Charts
import Models
import SwiftUI

public struct CardioFitnessLineChartView: View {
    private let readings: [CardioFitnessReading]
    private let window: CardioFitnessWindow

    public init(readings: [CardioFitnessReading], window: CardioFitnessWindow) {
        self.readings = readings
        self.window = window
    }

    public var body: some View {
        Group {
            if readings.isEmpty {
                Text("No VO₂ max readings in this window.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Chart(sortedReadings) { reading in
                    LineMark(
                        x: .value("Time", reading.endDate),
                        y: .value("VO₂ Max", reading.vo2Max)
                    )
                    .foregroundStyle(Color.green.gradient)
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

private extension CardioFitnessLineChartView {
    var sortedReadings: [CardioFitnessReading] {
        readings.sorted { $0.endDate < $1.endDate }
    }

    var yDomain: ClosedRange<Double> {
        let values = readings.map(\.vo2Max)
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
        CardioFitnessReading(vo2Max: 38.4, date: Date().addingTimeInterval(-3600), startDate: Date().addingTimeInterval(-3700), endDate: Date().addingTimeInterval(-3600)),
        CardioFitnessReading(vo2Max: 41.1, date: Date().addingTimeInterval(-1800), startDate: Date().addingTimeInterval(-1900), endDate: Date().addingTimeInterval(-1800)),
        CardioFitnessReading(vo2Max: 39.6, date: Date().addingTimeInterval(-900), startDate: Date().addingTimeInterval(-1000), endDate: Date().addingTimeInterval(-900))
    ]
    return CardioFitnessLineChartView(readings: readings, window: .day)
        .padding()
}
#endif
