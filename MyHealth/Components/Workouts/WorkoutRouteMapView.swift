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
        if let region = region {
            Map(position: .constant(.region(region))) {
                MapPolyline(coordinates: coordinates)
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

    private var coordinates: [CLLocationCoordinate2D] {
        points.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }

    private var region: MKCoordinateRegion? {
        guard !points.isEmpty else { return nil }
        let latitudes = points.map(\.latitude)
        let longitudes = points.map(\.longitude)
        guard let minLat = latitudes.min(),
              let maxLat = latitudes.max(),
              let minLon = longitudes.min(),
              let maxLon = longitudes.max()
        else { return nil }

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        let latDelta = max((maxLat - minLat) * 1.2, 0.005)
        let lonDelta = max((maxLon - minLon) * 1.2, 0.005)
        return MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        )
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
