//
//  WorkoutRoutePoint+MapRegion.swift
//  MyHealth
//
//  Created by Codex.
//

import MapKit
import Models

public extension Array where Element == WorkoutRoutePoint {
    var routeCoordinates: [CLLocationCoordinate2D] {
        map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }

    var routeRegion: MKCoordinateRegion? {
        guard !isEmpty else { return nil }
        let latitudes = map(\.latitude)
        let longitudes = map(\.longitude)
        guard let minLat = latitudes.min(),
              let maxLat = latitudes.max(),
              let minLon = longitudes.min(),
              let maxLon = longitudes.max()
        else { return nil }

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        let latDelta = Swift.max((maxLat - minLat) * 1.2, 0.005)
        let lonDelta = Swift.max((maxLon - minLon) * 1.2, 0.005)
        return MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        )
    }
}
