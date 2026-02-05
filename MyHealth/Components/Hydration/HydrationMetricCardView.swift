//
//  HydrationMetricCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct HydrationMetricCardView: View {
    private let title: String
    private let value: String
    private let icon: String
    private let tint: Color

    public init(title: String, value: String, icon: String, tint: Color) {
        self.title = title
        self.value = value
        self.icon = icon
        self.tint = tint
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(tint)
                    .frame(width: 22, height: 22)
                    .background(tint.opacity(0.15), in: Circle())
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            Text(value)
                .font(.title3.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(UIColor.systemBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#if DEBUG
#Preview {
    HStack {
        HydrationMetricCardView(title: "Today", value: "1.6 L", icon: "drop.fill", tint: .blue)
        HydrationMetricCardView(title: "Week Avg", value: "1.2 L", icon: "chart.bar.fill", tint: .teal)
    }
    .padding()
}
#endif
