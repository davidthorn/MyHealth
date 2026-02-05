//
//  SleepRecentNightCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct SleepRecentNightCardView: View {
    private let day: SleepDay
    private let formattedDuration: String

    public init(day: SleepDay, formattedDuration: String) {
        self.day = day
        self.formattedDuration = formattedDuration
    }

    public var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.indigo.opacity(0.85), Color.blue.opacity(0.85)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Image(systemName: "moon.stars.fill")
                    .font(.title3)
                    .foregroundStyle(.white)
            }
            .frame(width: 52, height: 52)

            VStack(alignment: .leading, spacing: 6) {
                Text(day.date.formatted(.dateTime.weekday(.wide)))
                    .font(.headline)
                Text(day.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(formattedDuration)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.indigo.opacity(0.15))
                )
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(UIColor.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.indigo.opacity(0.2), lineWidth: 1)
        )
    }
}

#if DEBUG
#Preview {
    SleepRecentNightCardView(
        day: SleepDay(date: Date().addingTimeInterval(-86400), durationSeconds: 7.5 * 3600),
        formattedDuration: "7h 30m"
    )
    .padding()
}
#endif
