//
//  SleepEntryRowView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct SleepEntryRowView: View {
    private let entry: SleepEntry

    public init(entry: SleepEntry) {
        self.entry = entry
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                ZStack {
                    Circle()
                        .fill(stageColor.opacity(0.18))
                    Image(systemName: stageIcon)
                        .foregroundStyle(stageColor)
                }
                .frame(width: 36, height: 36)

                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.category.title)
                        .font(.headline)
                    Text(timeRangeText)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(durationText)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(stageColor.opacity(0.15))
                    )
            }

            HStack(spacing: 10) {
                tag(text: entry.isUserEntered ? "User Entered" : "Auto", systemImage: "person.fill")
                if let sourceName = entry.sourceName {
                    tag(text: sourceName, systemImage: "app.badge")
                }
                if let deviceName = entry.deviceName {
                    tag(text: deviceName, systemImage: "applewatch")
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(UIColor.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(stageColor.opacity(0.25), lineWidth: 1)
        )
    }

    private var timeRangeText: String {
        let calendar = Calendar.current
        if calendar.isDate(entry.startDate, inSameDayAs: entry.endDate) {
            let dateText = entry.startDate.formatted(date: .abbreviated, time: .omitted)
            let startTime = entry.startDate.formatted(date: .omitted, time: .shortened)
            let endTime = entry.endDate.formatted(date: .omitted, time: .shortened)
            return "\(dateText) • \(startTime) → \(endTime)"
        } else {
            let start = entry.startDate.formatted(date: .abbreviated, time: .shortened)
            let end = entry.endDate.formatted(date: .abbreviated, time: .shortened)
            return "\(start) → \(end)"
        }
    }

    private var durationText: String {
        let totalMinutes = Int(entry.durationSeconds / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }

    private var stageColor: Color {
        switch entry.category {
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
        switch entry.category {
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

    private func tag(text: String, systemImage: String) -> some View {
        Label(text, systemImage: systemImage)
            .font(.caption2.weight(.semibold))
            .foregroundStyle(.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(Color(UIColor.secondarySystemBackground))
            )
    }
}

#if DEBUG
#Preview {
    SleepEntryRowView(
        entry: SleepEntry(
            id: UUID(),
            startDate: Date().addingTimeInterval(-8 * 3600),
            endDate: Date(),
            category: .asleep,
            isUserEntered: true,
            sourceName: "MyHealth",
            deviceName: "Apple Watch"
        )
    )
    .padding()
}
#endif
