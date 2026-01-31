//
//  ActivityRingsStackView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct ActivityRingsStackView: View {
    private let moveProgress: Double
    private let exerciseProgress: Double
    private let standProgress: Double
    private let size: CGFloat

    public init(
        moveProgress: Double,
        exerciseProgress: Double,
        standProgress: Double,
        size: CGFloat = 96
    ) {
        self.moveProgress = moveProgress
        self.exerciseProgress = exerciseProgress
        self.standProgress = standProgress
        self.size = size
    }

    public var body: some View {
        ZStack {
            ActivityRingView(progress: moveProgress, color: .pink, lineWidth: size * 0.14)
                .frame(width: size, height: size)
            ActivityRingView(progress: exerciseProgress, color: .green, lineWidth: size * 0.12)
                .frame(width: size * 0.76, height: size * 0.76)
            ActivityRingView(progress: standProgress, color: .blue, lineWidth: size * 0.1)
                .frame(width: size * 0.52, height: size * 0.52)
        }
    }
}

#if DEBUG
#Preview {
    ActivityRingsStackView(moveProgress: 0.8, exerciseProgress: 0.6, standProgress: 0.4)
        .frame(width: 140, height: 140)
        .padding()
}
#endif
