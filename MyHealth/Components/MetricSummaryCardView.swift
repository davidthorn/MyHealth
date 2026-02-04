//
//  MetricSummaryCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct MetricSummaryCardView: View {
    private let category: MetricsCategory
    private let value: String
    private let unit: String?
    private let subtitle: String
    private let trend: String

    public init(category: MetricsCategory, value: String, unit: String?, subtitle: String, trend: String) {
        self.category = category
        self.value = value
        self.unit = unit
        self.subtitle = subtitle
        self.trend = trend
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: iconName)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(accentColor)
                    .frame(width: 28, height: 28)
                    .background(accentColor.opacity(0.15), in: Circle())
                Text(category.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                Spacer(minLength: 0)
            }

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(value)
                    .font(valueFont)
                    .lineLimit(1)
                    .minimumScaleFactor(valueScaleFactor)
                    .allowsTightening(true)
                    .monospacedDigit()
                if let unit, !unit.isEmpty, value != "—" {
                    Text(unit)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            }

            HStack(spacing: 8) {
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Spacer(minLength: 0)
                Text(trend)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(accentColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(accentColor.opacity(0.12), in: Capsule())
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 140, maxHeight: 140, alignment: .topLeading)
        .background(Color(UIColor.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private extension MetricSummaryCardView {
    var accentColor: Color {
        switch category {
        case .heartRate:
            return .red
        case .cardioFitness:
            return .teal
        case .bloodOxygen:
            return .blue
        case .heartRateVariability:
            return .purple
        case .restingHeartRate:
            return .pink
        case .steps:
            return .green
        case .flights:
            return .orange
        case .standHours:
            return .indigo
        case .exerciseMinutes:
            return .orange
        case .calories:
            return .red
        case .sleep:
            return .indigo
        case .activityRings:
            return .pink
        }
    }

    var iconName: String {
        switch category {
        case .heartRate:
            return "heart.fill"
        case .cardioFitness:
            return "wind"
        case .bloodOxygen:
            return "drop.fill"
        case .heartRateVariability:
            return "waveform.path.ecg"
        case .restingHeartRate:
            return "bed.double.fill"
        case .steps:
            return "figure.walk"
        case .flights:
            return "figure.stairs"
        case .standHours:
            return "figure.stand"
        case .exerciseMinutes:
            return "figure.run"
        case .calories:
            return "flame.fill"
        case .sleep:
            return "moon.fill"
        case .activityRings:
            return "circle.dashed.inset.filled"
        }
    }

    var valueFont: Font {
        category == .cardioFitness ? .title3.weight(.bold) : .title.weight(.bold)
    }

    var valueScaleFactor: CGFloat {
        category == .cardioFitness ? 0.6 : 0.7
    }
}

#if DEBUG
#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 1) {
        MetricSummaryCardView(category: .heartRate, value: "72", unit: "bpm", subtitle: "Avg today", trend: "▼ 3 bpm")
        MetricSummaryCardView(category: .cardioFitness, value: "42.3", unit: "ml/kg/min", subtitle: "Latest", trend: "▲ 0.4")
    }
    .frame(maxWidth: .infinity)
    .padding()
}
#endif
