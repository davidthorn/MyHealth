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
            HStack(alignment: .top) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                Spacer()
                Text(trend)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
            }
            Text(value)
                .font(.title2.weight(.bold))
            Text(subtitle)
                .font(.footnote)
                .foregroundStyle(.secondary)
            Spacer(minLength: 0)
        }
        .padding(.top, 10)
        .padding(.horizontal, 14)
        .padding(.bottom, 14)
        .frame(maxWidth: .infinity, minHeight: 120, maxHeight: 150, alignment: .topLeading)
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
