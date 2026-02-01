//
//  NutritionTypeRowView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct NutritionTypeRowView: View {
    private let type: NutritionType

    public init(type: NutritionType) {
        self.type = type
    }

    public var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                Text(type.title)
                    .font(.headline)
                Text("View entries")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(type.unit)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule().fill(accentColor.opacity(0.18))
                )
                .foregroundStyle(accentColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [accentColor.opacity(0.18), accentColor.opacity(0.04)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(accentColor.opacity(0.25), lineWidth: 1)
        )
    }
}

private extension NutritionTypeRowView {
    var accentColor: Color {
        switch type {
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
#Preview("Nutrition Type Row") {
    NutritionTypeRowView(type: .protein)
        .padding()
}
#endif
