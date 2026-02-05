//
//  TodayHydrationCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct TodayHydrationCardView: View {
    private let hydrationText: String

    public init(hydrationText: String) {
        self.hydrationText = hydrationText
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "drop.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.blue)
                    .frame(width: 22, height: 22)
                    .background(Color.blue.opacity(0.15), in: Circle())
                Text("Hydration")
                    .font(.subheadline.weight(.semibold))
                Spacer()
            }

            Text(hydrationText)
                .font(.title3.weight(.semibold))
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

#if DEBUG
#Preview {
    TodayHydrationCardView(hydrationText: "1.6 L")
        .padding()
}
#endif
