//
//  SleepNightRowView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct SleepNightRowView: View {
    private let day: SleepDay
    private let formattedDuration: String

    public init(day: SleepDay, formattedDuration: String) {
        self.day = day
        self.formattedDuration = formattedDuration
    }

    public var body: some View {
        HStack {
            Text(day.date.formatted(date: .abbreviated, time: .omitted))
                .font(.subheadline.weight(.semibold))
            Spacer()
            Text(formattedDuration)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#if DEBUG
#Preview {
    SleepNightRowView(
        day: SleepDay(date: Date(), durationSeconds: 18_000),
        formattedDuration: "5h 0m"
    )
    .padding()
}
#endif
