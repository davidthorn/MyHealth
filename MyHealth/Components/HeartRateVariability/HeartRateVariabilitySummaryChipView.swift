//
//  HeartRateVariabilitySummaryChipView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct HeartRateVariabilitySummaryChipView: View {
    private let title: String
    private let value: String
    private let icon: String

    public init(title: String, value: String, icon: String) {
        self.title = title
        self.value = value
        self.icon = icon
    }

    public var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.purple)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Text(value)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            Spacer()
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#if DEBUG
#Preview {
    HStack(spacing: 12) {
        HeartRateVariabilitySummaryChipView(title: "Avg", value: "52 ms", icon: "waveform.path.ecg")
        HeartRateVariabilitySummaryChipView(title: "Low", value: "41 ms", icon: "arrow.down")
        HeartRateVariabilitySummaryChipView(title: "High", value: "74 ms", icon: "arrow.up")
    }
    .padding()
}
#endif
