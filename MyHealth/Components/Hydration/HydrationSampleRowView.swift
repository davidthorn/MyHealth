//
//  HydrationSampleRowView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct HydrationSampleRowView: View {
    private let sample: NutritionSample

    public init(sample: NutritionSample) {
        self.sample = sample
    }

    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "drop.fill")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.blue)
                .frame(width: 26, height: 26)
                .background(Color.blue.opacity(0.15), in: Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(formattedValue)
                    .font(.subheadline.weight(.semibold))
                Text(sample.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(12)
        .background(Color(UIColor.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var formattedValue: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = sample.value >= 100 ? 0 : 1
        let value = formatter.string(from: NSNumber(value: sample.value)) ?? "\(sample.value)"
        return "\(value) \(sample.unit)"
    }
}

#if DEBUG
#Preview {
    HydrationSampleRowView(
        sample: NutritionSample(type: .water, date: Date(), value: 350, unit: "ml")
    )
    .padding()
}
#endif
