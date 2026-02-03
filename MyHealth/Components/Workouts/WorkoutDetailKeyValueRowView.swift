//
//  WorkoutDetailKeyValueRowView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct WorkoutDetailKeyValueRowView: View {
    private let title: String
    private let value: String

    public init(title: String, value: String) {
        self.title = title
        self.value = value
    }

    public var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
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
    WorkoutDetailKeyValueRowView(title: "Start", value: "Feb 3, 6:40 PM")
        .padding()
        .background(Color(UIColor.tertiarySystemGroupedBackground))
}
#endif
