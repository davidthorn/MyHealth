//
//  WorkoutSplitRowView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct WorkoutSplitRowView: View {
    private let index: Int
    private let durationText: String
    private let paceText: String
    private let heartRateText: String?

    public init(index: Int, durationText: String, paceText: String, heartRateText: String?) {
        self.index = index
        self.durationText = durationText
        self.paceText = paceText
        self.heartRateText = heartRateText
    }

    public var body: some View {
        HStack(spacing: 0) {
            Text("\(index)")
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(durationText)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .center)

            Text(paceText)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .center)

            Text(heartRateText ?? "—")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#if DEBUG
#Preview {
    WorkoutSplitRowView(index: 1, durationText: "5:32", paceText: "5:32 /km", heartRateText: "142 bpm")
        .padding()
}
#endif
