//
//  RestingHeartRateReadingRowView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct RestingHeartRateReadingRowView: View {
    private let reading: RestingHeartRateReading

    public init(reading: RestingHeartRateReading) {
        self.reading = reading
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.12))
                        .frame(width: 42, height: 42)
                    Image(systemName: "heart.fill")
                        .foregroundStyle(Color.red)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(Int(reading.bpm.rounded())) bpm")
                        .font(.title3.weight(.bold))
                    Text(reading.startDate.formatted(date: .abbreviated, time: .shortened))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            HStack(spacing: 12) {
                RestingHeartRateMetaChip(
                    title: "Start",
                    value: reading.startDate.formatted(date: .omitted, time: .shortened),
                    systemImage: "play.fill"
                )
                RestingHeartRateMetaChip(
                    title: "End",
                    value: reading.endDate.formatted(date: .omitted, time: .shortened),
                    systemImage: "stop.fill"
                )
            }

            VStack(alignment: .leading, spacing: 6) {
                RestingHeartRateMetaRow(label: "Source", value: reading.sourceName)
                if let deviceName = reading.deviceName, !deviceName.isEmpty {
                    RestingHeartRateMetaRow(label: "Device", value: deviceName)
                }
            }

            if !reading.metadata.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Metadata")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    ForEach(reading.metadata.keys.sorted(), id: \.self) { key in
                        RestingHeartRateMetaRow(label: key, value: reading.metadata[key] ?? "")
                    }
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.secondary.opacity(0.08))
        )
    }
}

private struct RestingHeartRateMetaChip: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.caption2.weight(.bold))
                .foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.caption)
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.secondary.opacity(0.12))
        )
    }
}

private struct RestingHeartRateMetaRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .leading)
            Text(value)
                .font(.caption)
        }
    }
}

#if DEBUG
#Preview {
    RestingHeartRateReadingRowView(
        reading: RestingHeartRateReading(
            id: UUID(),
            bpm: 58,
            startDate: Date(),
            endDate: Date(),
            sourceName: "Apple Watch",
            sourceBundleIdentifier: "com.apple.health",
            deviceName: "Apple Watch",
            metadata: ["HKWasUserEntered": "false"]
        )
    )
    .padding()
}
#endif
