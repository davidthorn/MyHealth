//
//  HeartRateVariabilityReadingRowView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct HeartRateVariabilityReadingRowView: View {
    private let reading: HeartRateVariabilityReading
    private let status: HeartRateVariabilityStatus
    private let timeText: String
    private let valueText: String

    public init(
        reading: HeartRateVariabilityReading,
        status: HeartRateVariabilityStatus,
        timeText: String,
        valueText: String
    ) {
        self.reading = reading
        self.status = status
        self.timeText = timeText
        self.valueText = valueText
    }

    public var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(statusColor.opacity(0.15))
                    .frame(width: 34, height: 34)
                Image(systemName: statusIcon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(statusColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(valueText)
                    .font(.subheadline.weight(.semibold))
                Text(timeText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(status.title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(statusColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(statusColor.opacity(0.15), in: Capsule())
        }
        .padding(.vertical, 4)
    }
}

private extension HeartRateVariabilityReadingRowView {
    var statusIcon: String {
        switch status {
        case .low: return "arrow.down"
        case .normal: return "waveform.path.ecg"
        case .high: return "arrow.up"
        @unknown default:
            fatalError()
        }
    }

    var statusColor: Color {
        switch status {
        case .low: return .blue
        case .normal: return .purple
        case .high: return .pink
        @unknown default:
            fatalError()
        }
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 12) {
        HeartRateVariabilityReadingRowView(
            reading: HeartRateVariabilityReading(milliseconds: 38, startDate: Date(), endDate: Date()),
            status: .low,
            timeText: "8:12 AM",
            valueText: "38 ms"
        )
        HeartRateVariabilityReadingRowView(
            reading: HeartRateVariabilityReading(milliseconds: 56, startDate: Date(), endDate: Date()),
            status: .normal,
            timeText: "10:34 AM",
            valueText: "56 ms"
        )
        HeartRateVariabilityReadingRowView(
            reading: HeartRateVariabilityReading(milliseconds: 72, startDate: Date(), endDate: Date()),
            status: .high,
            timeText: "2:45 PM",
            valueText: "72 ms"
        )
    }
    .padding()
}
#endif
