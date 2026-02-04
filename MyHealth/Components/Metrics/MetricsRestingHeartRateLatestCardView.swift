//
//  MetricsRestingHeartRateLatestCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct MetricsRestingHeartRateLatestCardView: View {
    private let latest: RestingHeartRateDay
    private let chartPoints: [HeartRateRangePoint]

    public init(latest: RestingHeartRateDay, chartPoints: [HeartRateRangePoint]) {
        self.latest = latest
        self.chartPoints = chartPoints
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "heart.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.red)
                    .frame(width: 26, height: 26)
                    .background(Color.red.opacity(0.15), in: Circle())
                Text("Latest Resting Heart Rate")
                    .font(.headline)
                Spacer()
            }
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(Int(latest.averageBpm.rounded())) bpm")
                        .font(.title3.weight(.semibold))
                    Text(latest.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            RestingHeartRateRangeChartView(
                points: chartPoints,
                xAxisFormat: .dateTime.month().day(),
                desiredXAxisCount: 5
            )
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

#if DEBUG
#Preview {
    MetricsRestingHeartRateLatestCardView(
        latest: RestingHeartRateDay(date: Date(), averageBpm: 58),
        chartPoints: [
            HeartRateRangePoint(date: Date().addingTimeInterval(-3600 * 24 * 3), bpm: 60),
            HeartRateRangePoint(date: Date().addingTimeInterval(-3600 * 24 * 2), bpm: 59),
            HeartRateRangePoint(date: Date().addingTimeInterval(-3600 * 24), bpm: 58),
            HeartRateRangePoint(date: Date(), bpm: 57)
        ]
    )
    .padding()
}
#endif
