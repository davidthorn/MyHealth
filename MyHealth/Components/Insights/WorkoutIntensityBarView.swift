//
//  WorkoutIntensityBarView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct WorkoutIntensityBarView: View {
    private let lowFraction: Double
    private let moderateFraction: Double
    private let highFraction: Double

    public init(
        lowFraction: Double,
        moderateFraction: Double,
        highFraction: Double
    ) {
        self.lowFraction = lowFraction
        self.moderateFraction = moderateFraction
        self.highFraction = highFraction
    }

    public var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            let lowWidth = width * lowFraction
            let moderateWidth = width * moderateFraction
            let highWidth = width * highFraction

            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: lowWidth, height: height)
                Rectangle()
                    .fill(Color.orange)
                    .frame(width: moderateWidth, height: height)
                Rectangle()
                    .fill(Color.red)
                    .frame(width: highWidth, height: height)
            }
            .clipShape(RoundedRectangle(cornerRadius: height / 2, style: .continuous))
        }
        .frame(height: 12)
    }
}

#if DEBUG
#Preview {
    WorkoutIntensityBarView(lowFraction: 0.4, moderateFraction: 0.35, highFraction: 0.25)
        .padding()
}
#endif
