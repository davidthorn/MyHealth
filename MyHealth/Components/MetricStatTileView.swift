//
//  MetricStatTileView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct MetricStatTileView: View {
    private let title: String
    private let value: String

    public init(title: String, value: String) {
        self.title = title
        self.value = value
    }

    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "chart.bar.fill")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.accentColor)
                .frame(width: 26, height: 26)
                .background(Color.accentColor.opacity(0.15), in: Circle())
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                Text(value)
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .monospacedDigit()
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
        .padding(12)
        .background(Color(UIColor.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#if DEBUG
#Preview {
    MetricStatTileView(title: "Average Heart Rate", value: "72 bpm")
        .padding()
}
#endif
