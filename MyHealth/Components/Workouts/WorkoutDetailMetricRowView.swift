//
//  WorkoutDetailMetricRowView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct WorkoutDetailMetricRowView: View {
    private let title: String
    private let value: String
    private let symbolName: String?
    private let accentColor: Color

    public init(title: String, value: String, symbolName: String?, accentColor: Color) {
        self.title = title
        self.value = value
        self.symbolName = symbolName
        self.accentColor = accentColor
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let symbolName {
                Image(systemName: symbolName)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(accentColor)
                    .frame(width: 18)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(UIColor.systemGroupedBackground))
        )
    }
}

#if DEBUG
#Preview {
    WorkoutDetailMetricRowView(title: "Weather", value: "Cloudy", symbolName: "cloud.fill", accentColor: .blue)
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
}
#endif
