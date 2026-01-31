//
//  MetricSummaryCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct MetricSummaryCardView: View {
    private let title: String
    private let value: String
    private let subtitle: String
    private let trend: String

    public init(title: String, value: String, subtitle: String, trend: String) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.trend = trend
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(trend)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            Text(value)
                .font(.title2.weight(.bold))
            Text(subtitle)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.secondary.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#if DEBUG
#Preview {
    MetricSummaryCardView(title: "Heart Rate", value: "72 bpm", subtitle: "Avg today", trend: "▼ 3 bpm")
        .padding()
}
#endif
