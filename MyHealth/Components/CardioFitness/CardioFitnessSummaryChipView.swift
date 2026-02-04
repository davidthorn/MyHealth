//
//  CardioFitnessSummaryChipView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct CardioFitnessSummaryChipView: View {
    private let title: String
    private let value: String
    private let unit: String
    private let icon: String

    public init(title: String, value: String, unit: String, icon: String) {
        self.title = title
        self.value = value
        self.unit = unit
        self.icon = icon
    }

    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Color.green)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.primary)
                if !unit.isEmpty, value != "—" {
                    Text(unit)
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#if DEBUG
#Preview {
    HStack {
        CardioFitnessSummaryChipView(title: "Avg", value: "42.3", unit: "ml/kg/min", icon: "wind")
        CardioFitnessSummaryChipView(title: "Low", value: "31.2", unit: "ml/kg/min", icon: "arrow.down")
        CardioFitnessSummaryChipView(title: "High", value: "55.4", unit: "ml/kg/min", icon: "arrow.up")
    }
    .padding()
}
#endif
