//
//  WorkoutDetailStatTileView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct WorkoutDetailStatTileView: View {
    private let title: String
    private let value: String
    private let systemImage: String
    private let tint: Color

    public init(title: String, value: String, systemImage: String, tint: Color) {
        self.title = title
        self.value = value
        self.systemImage = systemImage
        self.tint = tint
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: systemImage)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(tint)
                Text(title)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(UIColor.systemGroupedBackground))
        )
    }
}

#if DEBUG
#Preview {
    HStack(spacing: 12) {
        WorkoutDetailStatTileView(title: "Distance", value: "4.20 km", systemImage: "map", tint: .blue)
        WorkoutDetailStatTileView(title: "Duration", value: "32:10", systemImage: "timer", tint: .orange)
    }
    .padding()
    .background(Color(UIColor.secondarySystemBackground))
}
#endif
