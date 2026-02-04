//
//  CardioFitnessDaySectionView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct CardioFitnessDaySectionView: View {
    private let title: String
    private let averageText: String
    private let minText: String
    private let maxText: String
    private let unitText: String
    private let readings: [CardioFitnessReading]
    private let valueText: (CardioFitnessReading) -> String
    private let timeText: (CardioFitnessReading) -> String
    private let level: (CardioFitnessReading) -> CardioFitnessLevel

    public init(
        title: String,
        averageText: String,
        minText: String,
        maxText: String,
        unitText: String,
        readings: [CardioFitnessReading],
        valueText: @escaping (CardioFitnessReading) -> String,
        timeText: @escaping (CardioFitnessReading) -> String,
        level: @escaping (CardioFitnessReading) -> CardioFitnessLevel
    ) {
        self.title = title
        self.averageText = averageText
        self.minText = minText
        self.maxText = maxText
        self.unitText = unitText
        self.readings = readings
        self.valueText = valueText
        self.timeText = timeText
        self.level = level
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)

            HStack(spacing: 12) {
                CardioFitnessSummaryChipView(title: "Avg", value: averageText, unit: unitText, icon: "wind")
                CardioFitnessSummaryChipView(title: "Low", value: minText, unit: unitText, icon: "arrow.down")
                CardioFitnessSummaryChipView(title: "High", value: maxText, unit: unitText, icon: "arrow.up")
            }

            VStack(spacing: 10) {
                ForEach(readings) { reading in
                    CardioFitnessReadingRowView(
                        reading: reading,
                        valueText: valueText(reading),
                        timeText: timeText(reading),
                        level: level(reading)
                    )
                }
            }
        }
        .padding(12)
        .background(Color(UIColor.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.green.opacity(0.12), lineWidth: 1)
        )
    }
}

#if DEBUG
#Preview {
    let readings = [
        CardioFitnessReading(vo2Max: 40.1, date: Date(), startDate: Date(), endDate: Date()),
        CardioFitnessReading(vo2Max: 43.5, date: Date(), startDate: Date(), endDate: Date())
    ]
    return CardioFitnessDaySectionView(
        title: "Today",
        averageText: "41.8",
        minText: "39.2",
        maxText: "45.0",
        unitText: "ml/kg/min",
        readings: readings,
        valueText: { _ in "41.8 ml/kg/min" },
        timeText: { _ in "9:12 AM" },
        level: { _ in .average }
    )
    .padding()
}
#endif
