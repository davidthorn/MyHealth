//
//  WorkoutDetailHeartRateSectionView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct WorkoutDetailHeartRateSectionView: View {
    private let points: [HeartRateRangePoint]

    public init(points: [HeartRateRangePoint]) {
        self.points = points
    }

    public var body: some View {
        Section("Heart Rate") {
            WorkoutHeartRateLineChartView(points: points)
        }
    }
}

#if DEBUG
#Preview {
    let points = [
        HeartRateRangePoint(date: Date().addingTimeInterval(-300), bpm: 120),
        HeartRateRangePoint(date: Date().addingTimeInterval(-200), bpm: 135),
        HeartRateRangePoint(date: Date().addingTimeInterval(-100), bpm: 128)
    ]
    return List {
        WorkoutDetailHeartRateSectionView(points: points)
    }
}
#endif
