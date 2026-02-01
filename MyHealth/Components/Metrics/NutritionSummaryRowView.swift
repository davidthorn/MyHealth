//
//  NutritionSummaryRowView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct NutritionSummaryRowView: View {
    private let total: NutritionDayTotal

    public init(total: NutritionDayTotal) {
        self.total = total
    }

    public var body: some View {
        HStack {
            Text(total.type.title)
                .font(.subheadline.weight(.semibold))
            Spacer()
            Text(valueText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }

    private var valueText: String {
        let formatted = String(format: "%.1f", total.value)
        return "\(formatted) \(total.unit)"
    }
}

#if DEBUG
#Preview("Nutrition Summary Row") {
    NutritionSummaryRowView(total: NutritionDayTotal(type: .protein, value: 54.2, unit: "g"))
        .padding()
}
#endif
