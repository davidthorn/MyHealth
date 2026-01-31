//
//  ActivityRingView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct ActivityRingView: View {
    private let progress: Double
    private let color: Color
    private let lineWidth: CGFloat

    public init(progress: Double, color: Color, lineWidth: CGFloat) {
        self.progress = progress
        self.color = color
        self.lineWidth = lineWidth
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.15), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            Circle()
                .trim(from: 0, to: min(max(progress, 0), 1))
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

#if DEBUG
#Preview {
    ActivityRingView(progress: 0.72, color: .pink, lineWidth: 14)
        .frame(width: 120, height: 120)
        .padding()
}
#endif
