//
//  CardioFitnessSummaryCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct CardioFitnessSummaryCardView: View {
    private let latest: CardioFitnessReading?
    private let averageText: String
    private let minText: String
    private let maxText: String
    private let unitText: String
    private let windowTitle: String
    private let isDayWindow: Bool
    private let latestValueText: String
    private let latestDateText: String

    public init(
        latest: CardioFitnessReading?,
        averageText: String,
        minText: String,
        maxText: String,
        unitText: String,
        windowTitle: String,
        isDayWindow: Bool,
        latestValueText: String,
        latestDateText: String
    ) {
        self.latest = latest
        self.averageText = averageText
        self.minText = minText
        self.maxText = maxText
        self.unitText = unitText
        self.windowTitle = windowTitle
        self.isDayWindow = isDayWindow
        self.latestValueText = latestValueText
        self.latestDateText = latestDateText
    }

    public var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: "wind")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.green)
                }
                VStack(alignment: .leading, spacing: 4) {
                    if isDayWindow {
                        Text(latestValueText)
                            .font(.title2.weight(.bold))
                        Text(latestDateText)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    } else {
                        Text(averageText)
                            .font(.title2.weight(.bold))
                        Text("Average \(windowTitle)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Image(systemName: "figure.run")
                    .font(.title3)
                    .foregroundStyle(Color.green.opacity(0.7))
            }

            HStack(spacing: 2) {
                CardioFitnessSummaryChipView(title: "Avg", value: averageText, unit: unitText, icon: "wind")
                CardioFitnessSummaryChipView(title: "Low", value: minText, unit: unitText, icon: "arrow.down")
                CardioFitnessSummaryChipView(title: "High", value: maxText, unit: unitText, icon: "arrow.up")
            }
        }
        .padding(12)
        .background(Color.green.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#if DEBUG
#Preview {
    CardioFitnessSummaryCardView(
        latest: CardioFitnessReading(vo2Max: 42.2, date: Date(), startDate: Date(), endDate: Date()),
        averageText: "41.8",
        minText: "30.1",
        maxText: "52.9",
        unitText: "ml/kg/min",
        windowTitle: "D",
        isDayWindow: true,
        latestValueText: "42.2 ml/kg/min",
        latestDateText: "Feb 4, 9:12 AM"
    )
    .padding()
}
#endif
