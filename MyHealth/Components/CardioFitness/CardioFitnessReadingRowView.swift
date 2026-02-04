//
//  CardioFitnessReadingRowView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct CardioFitnessReadingRowView: View {
    private let reading: CardioFitnessReading
    private let valueText: String
    private let timeText: String
    private let level: CardioFitnessLevel

    public init(
        reading: CardioFitnessReading,
        valueText: String,
        timeText: String,
        level: CardioFitnessLevel
    ) {
        self.reading = reading
        self.valueText = valueText
        self.timeText = timeText
        self.level = level
    }

    public var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(levelColor.opacity(0.15))
                    .frame(width: 36, height: 36)
                Image(systemName: levelIcon)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(levelColor)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(valueText)
                    .font(.subheadline.weight(.semibold))
                Text(timeText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(level.title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(levelColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(levelColor.opacity(0.12), in: Capsule())
        }
        .padding(12)
        .background(Color(UIColor.systemBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

private extension CardioFitnessReadingRowView {
    var levelColor: Color {
        switch level {
        case .low: return .red
        case .belowAverage: return .orange
        case .average: return .green
        case .aboveAverage: return .mint
        case .high: return .blue
        }
    }

    var levelIcon: String {
        switch level {
        case .low: return "arrow.down"
        case .belowAverage: return "arrow.down.right"
        case .average: return "arrow.right"
        case .aboveAverage: return "arrow.up.right"
        case .high: return "arrow.up"
        }
    }
}

#if DEBUG
#Preview {
    CardioFitnessReadingRowView(
        reading: CardioFitnessReading(vo2Max: 41.2, date: Date(), startDate: Date(), endDate: Date()),
        valueText: "41.2 ml/kg/min",
        timeText: "9:12 AM",
        level: .average
    )
    .padding()
}
#endif
