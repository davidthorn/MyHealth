//
//  TodayActivityStatsCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct TodayActivityStatsCardView: View {
    private let steps: String
    private let activeEnergy: String
    private let exerciseMinutes: String
    private let standHours: String

    public init(steps: String, activeEnergy: String, exerciseMinutes: String, standHours: String) {
        self.steps = steps
        self.activeEnergy = activeEnergy
        self.exerciseMinutes = exerciseMinutes
        self.standHours = standHours
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "flame.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.orange)
                    .frame(width: 22, height: 22)
                    .background(Color.orange.opacity(0.15), in: Circle())
                Text("Activity")
                    .font(.subheadline.weight(.semibold))
                Spacer()
            }

            VStack(spacing: 10) {
                HStack(spacing: 12) {
                    statPill(title: "Steps", value: steps, icon: "figure.walk", tint: .green)
                    statPill(title: "Active Energy", value: activeEnergy, icon: "flame", tint: .orange)
                }
                HStack(spacing: 12) {
                    statPill(title: "Exercise", value: exerciseMinutes, icon: "figure.run", tint: .blue)
                    statPill(title: "Stand", value: standHours, icon: "figure.stand", tint: .indigo)
                }
            }
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func statPill(title: String, value: String, icon: String, tint: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(tint)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.footnote.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .monospacedDigit()
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(tint.opacity(0.12), in: Capsule())
    }
}

#if DEBUG
#Preview {
    TodayActivityStatsCardView(
        steps: "8,420",
        activeEnergy: "420 kcal",
        exerciseMinutes: "42 min",
        standHours: "9 hr"
    )
        .padding()
}
#endif
