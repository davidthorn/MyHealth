//
//  WorkoutRouteMapView.swift
//  MyHealth
//
//  Created by Codex.
//

import MapKit
import Models
import SwiftUI

public struct WorkoutRouteMapView: View {
    private let points: [WorkoutRoutePoint]
    private let height: CGFloat?

    public init(points: [WorkoutRoutePoint], height: CGFloat? = 220) {
        self.points = points
        self.height = height
    }

    public var body: some View {
        if let region = points.routeRegion {
            Map(position: .constant(.region(region))) {
                MapPolyline(coordinates: points.routeCoordinates)
                    .stroke(Color.blue, lineWidth: 4)
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .frame(maxHeight: height == nil ? .infinity : nil)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        } else {
            ContentUnavailableView("No Route", systemImage: "map", description: Text("No GPS route was recorded for this workout."))
        }
    }
}

#if DEBUG
#Preview {
    WorkoutRouteMapView(points: [
        WorkoutRoutePoint(latitude: 37.332, longitude: -122.031, timestamp: Date()),
        WorkoutRoutePoint(latitude: 37.333, longitude: -122.029, timestamp: Date().addingTimeInterval(60)),
        WorkoutRoutePoint(latitude: 37.334, longitude: -122.028, timestamp: Date().addingTimeInterval(120))
    ])
    .padding()
}
#endif
