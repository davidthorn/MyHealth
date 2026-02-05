//
//  SleepStageMetricChipView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct SleepStageMetricChipView: View {
    private let summary: SleepEntryCategorySummary
    private let durationText: String

    public init(summary: SleepEntryCategorySummary, durationText: String) {
        self.summary = summary
        self.durationText = durationText
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(stageColor.opacity(0.18))
                    Image(systemName: stageIcon)
                        .font(.caption)
                        .foregroundStyle(stageColor)
                }
                .frame(width: 26, height: 26)
                Text(summary.category.title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(durationText)
                .font(.headline)
                .foregroundStyle(.primary)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(UIColor.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(stageColor.opacity(0.25))
        )
    }

    private var stageColor: Color {
        switch summary.category {
        case .inBed:
            return .blue
        case .asleep:
            return .indigo
        case .asleepCore:
            return .teal
        case .asleepDeep:
            return .purple
        case .asleepREM:
            return .pink
        case .awake:
            return .orange
        }
    }

    private var stageIcon: String {
        switch summary.category {
        case .inBed:
            return "bed.double.fill"
        case .asleep:
            return "moon.fill"
        case .asleepCore:
            return "waveform.path.ecg"
        case .asleepDeep:
            return "moon.zzz.fill"
        case .asleepREM:
            return "sparkles"
        case .awake:
            return "sun.max.fill"
        }
    }
}

#if DEBUG
#Preview {
    SleepStageMetricChipView(
        summary: SleepEntryCategorySummary(category: .asleepDeep, durationSeconds: 5400),
        durationText: "1h 30m"
    )
    .padding()
}
#endif
