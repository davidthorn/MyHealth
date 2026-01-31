//
//  RestingHeartRateRangeChartView.swift
//  MyHealth
//
//  Created by Codex.
//

import Charts
import Models
import SwiftUI

public struct RestingHeartRateRangeChartView: View {
    private let points: [HeartRateRangePoint]
    private let xAxisFormat: Date.FormatStyle
    private let desiredXAxisCount: Int

    public init(
        points: [HeartRateRangePoint],
        xAxisFormat: Date.FormatStyle = .dateTime.hour().minute(),
        desiredXAxisCount: Int = 4
    ) {
        self.points = points
        self.xAxisFormat = xAxisFormat
        self.desiredXAxisCount = desiredXAxisCount
    }

    public var body: some View {
        Group {
            if points.isEmpty {
                Text("No heart rate samples in this window.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                let maxBpm = points.map(\.bpm).max() ?? 0
                let upperBound = max(maxBpm * 1.1, 1)
                Chart(points) { point in
                    LineMark(
                        x: .value("Time", point.date),
                        y: .value("BPM", point.bpm)
                    )
                    .foregroundStyle(Color.red.gradient)
                    .interpolationMethod(.catmullRom)
                }
                .chartYScale(domain: 0...upperBound)
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: desiredXAxisCount)) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: xAxisFormat, centered: true)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading, values: .automatic(desiredCount: 3))
                }
                .frame(height: 140)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 4)
    }
}

#if DEBUG
#Preview {
    RestingHeartRateRangeChartView(
        points: [
            HeartRateRangePoint(date: Date().addingTimeInterval(-300), bpm: 62),
            HeartRateRangePoint(date: Date().addingTimeInterval(-240), bpm: 66),
            HeartRateRangePoint(date: Date().addingTimeInterval(-180), bpm: 61),
            HeartRateRangePoint(date: Date().addingTimeInterval(-120), bpm: 64),
            HeartRateRangePoint(date: Date().addingTimeInterval(-60), bpm: 63)
        ]
    )
    .padding()
}
#endif
