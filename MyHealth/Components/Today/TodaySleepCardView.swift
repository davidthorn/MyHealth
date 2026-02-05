//
//  TodaySleepCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct TodaySleepCardView: View {
    private let day: SleepDay
    private let formattedDuration: String

    public init(day: SleepDay, formattedDuration: String) {
        self.day = day
        self.formattedDuration = formattedDuration
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "bed.double.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.indigo)
                    .frame(width: 22, height: 22)
                    .background(Color.indigo.opacity(0.15), in: Circle())
                Text("Sleep")
                    .font(.subheadline.weight(.semibold))
                Spacer()
            }
            SleepLatestCardView(day: day, formattedDuration: formattedDuration)
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

#if DEBUG
#Preview {
    TodaySleepCardView(
        day: SleepDay(date: Date().addingTimeInterval(-86400), durationSeconds: 7_200),
        formattedDuration: "2h 0m"
    )
    .padding()
}
#endif
