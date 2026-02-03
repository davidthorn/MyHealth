//
//  WorkoutDetailRouteSectionView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct WorkoutDetailRouteSectionView: View {
    private let points: [WorkoutRoutePoint]
    private let onFullScreen: () -> Void

    public init(points: [WorkoutRoutePoint], onFullScreen: @escaping () -> Void) {
        self.points = points
        self.onFullScreen = onFullScreen
    }

    public var body: some View {
        WorkoutDetailCardView(title: "Route", actionTitle: "Full Screen", action: onFullScreen) {
            WorkoutRouteMapView(points: points)
                .frame(maxWidth: .infinity)
        }
    }
}

#if DEBUG
#Preview {
    ScrollView {
        WorkoutDetailRouteSectionView(
            points: [
                WorkoutRoutePoint(latitude: 37.332, longitude: -122.031, timestamp: Date(), horizontalAccuracy: nil),
                WorkoutRoutePoint(latitude: 37.333, longitude: -122.029, timestamp: Date().addingTimeInterval(60), horizontalAccuracy: nil)
            ],
            onFullScreen: {}
        )
        .padding()
    }
}
#endif
