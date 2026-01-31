//
//  WorkoutRouteFullScreenView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct WorkoutRouteFullScreenView: View {
    @Environment(\.dismiss) private var dismiss
    private let points: [WorkoutRoutePoint]

    public init(points: [WorkoutRoutePoint]) {
        self.points = points
    }

    public var body: some View {
        NavigationStack {
            WorkoutRouteMapView(points: points, height: nil)
                .ignoresSafeArea(edges: .bottom)
                .navigationTitle("Workout Route")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
        }
    }
}

#if DEBUG
#Preview {
    WorkoutRouteFullScreenView(points: [
        WorkoutRoutePoint(latitude: 37.332, longitude: -122.031, timestamp: Date()),
        WorkoutRoutePoint(latitude: 37.333, longitude: -122.029, timestamp: Date().addingTimeInterval(60)),
        WorkoutRoutePoint(latitude: 37.334, longitude: -122.028, timestamp: Date().addingTimeInterval(120))
    ])
}
#endif
