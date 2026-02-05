//
//  SleepSummaryHeaderView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct SleepSummaryHeaderView: View {
    private let title: String
    private let durationText: String

    public init(title: String, durationText: String) {
        self.title = title
        self.durationText = durationText
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Image(systemName: "bed.double.fill")
                    .foregroundStyle(.indigo)
                Text(durationText)
                    .font(.title2.weight(.bold))
            }
            Text("Total sleep duration")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
}

#if DEBUG
#Preview {
    SleepSummaryHeaderView(title: "Wednesday, Feb 5, 2026", durationText: "7h 42m")
        .padding()
}
#endif
