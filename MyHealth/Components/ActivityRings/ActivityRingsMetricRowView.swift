//
//  ActivityRingsMetricRowView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct ActivityRingsMetricRowView: View {
    private let title: String
    private let value: String
    private let goal: String

    public init(title: String, value: String, goal: String) {
        self.title = title
        self.value = value
        self.goal = goal
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            HStack {
                Text(value)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(goal)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.secondary.opacity(0.08))
        )
    }
}

#if DEBUG
#Preview {
    ActivityRingsMetricRowView(title: "Move", value: "420 kcal", goal: "Goal 600")
        .padding()
}
#endif
