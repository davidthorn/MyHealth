//
//  WorkoutSelectionRowView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct WorkoutSelectionRowView: View {
    private let type: WorkoutType
    private let onStart: () -> Void

    public init(type: WorkoutType, onStart: @escaping () -> Void) {
        self.type = type
        self.onStart = onStart
    }

    public var body: some View {
        Button(action: onStart) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(tintColor.opacity(0.18))
                        .frame(width: 52, height: 52)
                    Image(systemName: iconName)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(tintColor)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(type.displayName)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(subtitleText)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(tintColor)
                        .frame(width: 42, height: 42)
                    Image(systemName: "play.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .offset(x: 1)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(tintColor.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(tintColor.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private extension WorkoutSelectionRowView {
    var tintColor: Color {
        switch type {
        case .running: return .red
        case .walking: return .green
        case .cycling: return .blue
        case .swimming: return .teal
        case .strength: return .orange
        case .yoga: return .pink
        case .other: return .gray
        }
    }

    var iconName: String {
        switch type {
        case .running: return "figure.run"
        case .walking: return "figure.walk"
        case .cycling: return "bicycle"
        case .swimming: return "figure.pool.swim"
        case .strength: return "dumbbell"
        case .yoga: return "figure.yoga"
        case .other: return "figure.mixed.cardio"
        }
    }

    var subtitleText: String {
        switch type {
        case .running: return "Track pace, splits, and heart rate"
        case .walking: return "Outdoor route with distance"
        case .cycling: return "Speed and distance tracking"
        case .swimming: return "Indoor or outdoor session"
        case .strength: return "Sets, reps, and effort"
        case .yoga: return "Flow and recovery"
        case .other: return "General workout session"
        }
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 12) {
        WorkoutSelectionRowView(type: .running, onStart: {})
        WorkoutSelectionRowView(type: .walking, onStart: {})
        WorkoutSelectionRowView(type: .cycling, onStart: {})
        WorkoutSelectionRowView(type: .strength, onStart: {})
        WorkoutSelectionRowView(type: .other, onStart: {})
    }
    .padding()
}
#endif
