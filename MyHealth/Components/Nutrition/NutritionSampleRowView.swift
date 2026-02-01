//
//  NutritionSampleRowView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct NutritionSampleRowView: View {
    private let sample: NutritionSample

    public init(sample: NutritionSample) {
        self.sample = sample
    }

    public var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                Text(sample.type.title)
                    .font(.headline)
                Text(sample.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 6) {
                Text(valueText)
                    .font(.headline)
                Text(sample.unit)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(accentColor)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(accentColor.opacity(0.18))
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [accentColor.opacity(0.16), accentColor.opacity(0.04)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(accentColor.opacity(0.22), lineWidth: 1)
        )
    }

    private var valueText: String {
        let formatted = String(format: "%.1f", sample.value)
        return formatted
    }
}

private extension NutritionSampleRowView {
    var accentColor: Color {
        switch sample.type {
        case .energy, .carbohydrate, .sugar, .sugarAlcohol:
            return Color(red: 0.93, green: 0.45, blue: 0.18)
        case .fatTotal, .fatSaturated, .fatMonounsaturated, .fatPolyunsaturated, .cholesterol:
            return Color(red: 0.88, green: 0.34, blue: 0.21)
        case .protein, .vitaminB6, .vitaminB12, .vitaminC:
            return Color(red: 0.20, green: 0.56, blue: 0.45)
        case .water:
            return Color(red: 0.14, green: 0.46, blue: 0.74)
        default:
            return Color(red: 0.55, green: 0.54, blue: 0.32)
        }
    }
}

#if DEBUG
#Preview("Nutrition Sample Row") {
    NutritionSampleRowView(
        sample: NutritionSample(
            type: .carbohydrate,
            date: Date(),
            value: 42.5,
            unit: "g"
        )
    )
    .padding()
}
#endif
