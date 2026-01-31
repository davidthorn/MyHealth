//
//  MetricFilterChipView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct MetricFilterChipView: View {
    private let title: String
    private let isSelected: Bool
    private let action: () -> Void

    public init(title: String, isSelected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Color.accentColor.opacity(0.2) : Color.secondary.opacity(0.15))
                .foregroundStyle(isSelected ? Color.accentColor : Color.primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#if DEBUG
#Preview {
    HStack {
        MetricFilterChipView(title: "Day", isSelected: true, action: {})
        MetricFilterChipView(title: "Week", isSelected: false, action: {})
    }
    .padding()
}
#endif
