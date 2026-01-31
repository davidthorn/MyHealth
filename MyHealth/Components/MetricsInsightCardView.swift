//
//  MetricsInsightCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct MetricsInsightCardView: View {
    private let title: String
    private let detail: String

    public init(title: String, detail: String) {
        self.title = title
        self.detail = detail
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                    .foregroundStyle(Color.accentColor)
                Text(title)
                    .font(.subheadline.weight(.semibold))
            }
            Text(detail)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#if DEBUG
#Preview("Metrics Insight Card") {
    MetricsInsightCardView(
        title: "Trend improving",
        detail: "Your resting heart rate is 3 bpm lower than last week."
    )
    .padding()
}
#endif
