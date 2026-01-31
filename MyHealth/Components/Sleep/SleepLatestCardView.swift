//
//  SleepLatestCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct SleepLatestCardView: View {
    private let day: SleepDay
    private let formattedDuration: String

    public init(day: SleepDay, formattedDuration: String) {
        self.day = day
        self.formattedDuration = formattedDuration
    }

    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(formattedDuration)
                    .font(.title2.weight(.bold))
                Text(day.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "bed.double")
                .font(.title2)
                .foregroundStyle(Color.accentColor)
        }
    }
}

#if DEBUG
#Preview {
    SleepLatestCardView(
        day: SleepDay(date: Date(), durationSeconds: 7_200),
        formattedDuration: "2h 0m"
    )
    .padding()
}
#endif
