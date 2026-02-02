//
//  CurrentWorkoutStatsView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct CurrentWorkoutStatsView: View {
    private let distanceText: String
    private let paceText: String
    private let speedText: String

    public init(distanceText: String, paceText: String, speedText: String) {
        self.distanceText = distanceText
        self.paceText = paceText
        self.speedText = speedText
    }

    public var body: some View {
        HStack(spacing: 12) {
            WorkoutStatTileView(title: "Distance", value: distanceText, systemImage: "figure.walk")
            WorkoutStatTileView(title: "Pace", value: paceText, systemImage: "speedometer")
            WorkoutStatTileView(title: "Speed", value: speedText, systemImage: "gauge.medium")
        }
    }
}

private struct WorkoutStatTileView: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: systemImage)
                    .font(.caption)
                    .foregroundStyle(Color.accentColor)
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(UIColor.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#if DEBUG
#Preview {
    CurrentWorkoutStatsView(distanceText: "1.42 km", paceText: "5:12 /km", speedText: "11.5 km/h")
        .padding()
}
#endif
