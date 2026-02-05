//
//  TodayRecoveryCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct TodayRecoveryCardView: View {
    private let restingDay: RestingHeartRateDay
    private let restingChartPoints: [HeartRateRangePoint]
    private let hrvReading: HeartRateVariabilityReading?

    public init(
        restingDay: RestingHeartRateDay,
        restingChartPoints: [HeartRateRangePoint],
        hrvReading: HeartRateVariabilityReading?
    ) {
        self.restingDay = restingDay
        self.restingChartPoints = restingChartPoints
        self.hrvReading = hrvReading
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "heart.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.pink)
                    .frame(width: 22, height: 22)
                    .background(Color.pink.opacity(0.15), in: Circle())
                Text("Recovery")
                    .font(.subheadline.weight(.semibold))
                Spacer()
            }

            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Resting HR")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(Int(restingDay.averageBpm.rounded())) bpm")
                        .font(.title3.weight(.semibold))
                }
                Spacer()
                if let hrvReading {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("HRV")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(Int(hrvReading.milliseconds.rounded())) ms")
                            .font(.title3.weight(.semibold))
                    }
                } else {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("HRV")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("—")
                            .font(.title3.weight(.semibold))
                    }
                }
            }

            RestingHeartRateRangeChartView(
                points: restingChartPoints,
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
    TodayRecoveryCardView(
        restingDay: RestingHeartRateDay(date: Date(), averageBpm: 58),
        restingChartPoints: [
            HeartRateRangePoint(date: Date().addingTimeInterval(-3600 * 24 * 3), bpm: 60),
            HeartRateRangePoint(date: Date().addingTimeInterval(-3600 * 24 * 2), bpm: 59),
            HeartRateRangePoint(date: Date().addingTimeInterval(-3600 * 24), bpm: 58),
            HeartRateRangePoint(date: Date(), bpm: 57)
        ],
        hrvReading: HeartRateVariabilityReading(milliseconds: 64, startDate: Date(), endDate: Date())
    )
    .padding()
}
#endif
