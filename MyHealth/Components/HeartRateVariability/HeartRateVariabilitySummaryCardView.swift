//
//  HeartRateVariabilitySummaryCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct HeartRateVariabilitySummaryCardView: View {
    private let latest: HeartRateVariabilityReading?
    private let averageText: String
    private let minText: String
    private let maxText: String
    private let windowTitle: String
    private let isDayWindow: Bool
    private let latestValueText: String
    private let latestDateText: String

    public init(
        latest: HeartRateVariabilityReading?,
        averageText: String,
        minText: String,
        maxText: String,
        windowTitle: String,
        isDayWindow: Bool,
        latestValueText: String,
        latestDateText: String
    ) {
        self.latest = latest
        self.averageText = averageText
        self.minText = minText
        self.maxText = maxText
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
                        .fill(Color.purple.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.purple)
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
                Image(systemName: "heart.text.square")
                    .font(.title3)
                    .foregroundStyle(Color.purple.opacity(0.7))
            }

            HStack(spacing: 12) {
                HeartRateVariabilitySummaryChipView(title: "Avg", value: averageText, icon: "waveform.path.ecg")
                HeartRateVariabilitySummaryChipView(title: "Low", value: minText, icon: "arrow.down")
                HeartRateVariabilitySummaryChipView(title: "High", value: maxText, icon: "arrow.up")
            }
        }
        .padding(12)
        .background(Color.purple.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#if DEBUG
#Preview {
    HeartRateVariabilitySummaryCardView(
        latest: HeartRateVariabilityReading(milliseconds: 58, startDate: Date(), endDate: Date()),
        averageText: "54 ms",
        minText: "42 ms",
        maxText: "76 ms",
        windowTitle: "D",
        isDayWindow: true,
        latestValueText: "58 ms",
        latestDateText: "Feb 4, 9:12 AM"
    )
    .padding()
}
#endif
