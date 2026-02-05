//
//  TodayVitalsCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct TodayVitalsCardView: View {
    private let latestHeartRate: String

    public init(latestHeartRate: String) {
        self.latestHeartRate = latestHeartRate
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "heart.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.red)
                    .frame(width: 22, height: 22)
                    .background(Color.red.opacity(0.15), in: Circle())
                Text("Latest Heart Rate")
                    .font(.subheadline.weight(.semibold))
                Spacer()
            }

            HStack {
                Text(latestHeartRate)
                    .font(.title3.weight(.semibold))
                Spacer()
            }
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

#if DEBUG
#Preview {
    TodayVitalsCardView(latestHeartRate: "72 bpm")
        .padding()
}
#endif
