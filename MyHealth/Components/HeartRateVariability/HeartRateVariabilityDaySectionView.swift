//
//  HeartRateVariabilityDaySectionView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct HeartRateVariabilityDaySectionView: View {
    private let title: String
    private let summary: (average: String, min: String, max: String)
    private let readings: [HeartRateVariabilityReading]
    private let status: (HeartRateVariabilityReading) -> HeartRateVariabilityStatus
    private let timeText: (HeartRateVariabilityReading) -> String
    private let valueText: (HeartRateVariabilityReading) -> String

    public init(
        title: String,
        summary: (average: String, min: String, max: String),
        readings: [HeartRateVariabilityReading],
        status: @escaping (HeartRateVariabilityReading) -> HeartRateVariabilityStatus,
        timeText: @escaping (HeartRateVariabilityReading) -> String,
        valueText: @escaping (HeartRateVariabilityReading) -> String
    ) {
        self.title = title
        self.summary = summary
        self.readings = readings
        self.status = status
        self.timeText = timeText
        self.valueText = valueText
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)

            HStack(spacing: 12) {
                HeartRateVariabilitySummaryChipView(title: "Avg", value: summary.average, icon: "waveform.path.ecg")
                HeartRateVariabilitySummaryChipView(title: "Low", value: summary.min, icon: "arrow.down")
                HeartRateVariabilitySummaryChipView(title: "High", value: summary.max, icon: "arrow.up")
            }

            LazyVStack(spacing: 8) {
                ForEach(readings) { reading in
                    HeartRateVariabilityReadingRowView(
                        reading: reading,
                        status: status(reading),
                        timeText: timeText(reading),
                        valueText: valueText(reading)
                    )
                }
            }
        }
        .padding(14)
        .background(Color(UIColor.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#if DEBUG
#Preview {
    let readings = [
        HeartRateVariabilityReading(milliseconds: 38, startDate: Date(), endDate: Date()),
        HeartRateVariabilityReading(milliseconds: 54, startDate: Date(), endDate: Date()),
        HeartRateVariabilityReading(milliseconds: 62, startDate: Date(), endDate: Date())
    ]
    return HeartRateVariabilityDaySectionView(
        title: "Feb 4",
        summary: ("52 ms", "38 ms", "62 ms"),
        readings: readings,
        status: { _ in .normal },
        timeText: { _ in "8:12 AM" },
        valueText: { _ in "52 ms" }
    )
    .padding()
}
#endif
