//
//  WorkoutHeartRateLineChartView.swift
//  MyHealth
//
//  Created by Codex.
//

import Charts
import Models
import SwiftUI

public struct WorkoutHeartRateLineChartView: View {
    private let points: [HeartRateRangePoint]

    public init(points: [HeartRateRangePoint]) {
        self.points = points
    }

    public var body: some View {
        Group {
            if points.isEmpty {
                Text("No heart rate samples recorded for this workout.")
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
                    AxisMarks(values: .automatic(desiredCount: 4)) { value in
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
    WorkoutHeartRateLineChartView(points: [
        HeartRateRangePoint(date: Date().addingTimeInterval(-600), bpm: 98),
        HeartRateRangePoint(date: Date().addingTimeInterval(-480), bpm: 112),
        HeartRateRangePoint(date: Date().addingTimeInterval(-360), bpm: 120),
        HeartRateRangePoint(date: Date().addingTimeInterval(-240), bpm: 115),
        HeartRateRangePoint(date: Date().addingTimeInterval(-120), bpm: 123),
        HeartRateRangePoint(date: Date(), bpm: 118)
    ])
    .padding()
}
#endif
