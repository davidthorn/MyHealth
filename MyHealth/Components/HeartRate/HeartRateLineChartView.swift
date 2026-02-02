//
//  HeartRateLineChartView.swift
//  MyHealth
//
//  Created by Codex.
//

import Charts
import Models
import SwiftUI

public struct HeartRateLineChartView: View {
    private let points: [HeartRateRangePoint]

    public init(points: [HeartRateRangePoint]) {
        self.points = points
    }

    public var body: some View {
        Group {
            if points.isEmpty {
                Text("No heart rate readings yet for today.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                let maxBpm = points.map(\.bpm).max() ?? 0
                let minBpm = points.map(\.bpm).min() ?? 0
                let upperBound = max(maxBpm * 1.1, 1)
                let lowerBound = max(minBpm * 0.9, 0)
                Chart(points) { point in
                    LineMark(
                        x: .value("Time", point.date),
                        y: .value("BPM", point.bpm)
                    )
                    .foregroundStyle(Color.red.gradient)
                    .interpolationMethod(.catmullRom)
                }
                .chartYScale(domain: lowerBound...upperBound)
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 4)) { _ in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .dateTime.hour().minute(), centered: true)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading, values: .automatic(desiredCount: 3))
                }
                .frame(height: 180)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 4)
    }
}

#if DEBUG
#Preview {
    HeartRateLineChartView(points: [
        HeartRateRangePoint(date: Date().addingTimeInterval(-3600), bpm: 78),
        HeartRateRangePoint(date: Date().addingTimeInterval(-2400), bpm: 92),
        HeartRateRangePoint(date: Date().addingTimeInterval(-1800), bpm: 105),
        HeartRateRangePoint(date: Date().addingTimeInterval(-900), bpm: 96),
        HeartRateRangePoint(date: Date(), bpm: 88)
    ])
    .padding()
}
#endif
