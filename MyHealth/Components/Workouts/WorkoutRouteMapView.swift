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
        let mapView = Group {
            if let region = points.routeRegion {
                Map(position: .constant(.region(region))) {
                    if points.count > 1 {
                        MapPolyline(coordinates: points.routeCoordinates)
                            .stroke(Color.blue, lineWidth: 4)
                    }
                }
            } else {
                Map(position: .constant(.automatic)) { }
            }
        }

        mapView
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .frame(maxHeight: height == nil ? .infinity : nil)
            .allowsHitTesting(false)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(alignment: .bottomLeading) {
                if points.isEmpty {
                    Label("Waiting for GPS", systemImage: "location")
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(.secondary)
                        .padding(10)
                        .background(.ultraThinMaterial, in: Capsule())
                        .padding(12)
                }
            }
    }
}

#if DEBUG
#Preview {
    WorkoutRouteMapView(points: [
        WorkoutRoutePoint(latitude: 37.332, longitude: -122.031, timestamp: Date(), horizontalAccuracy: nil),
        WorkoutRoutePoint(latitude: 37.333, longitude: -122.029, timestamp: Date().addingTimeInterval(60), horizontalAccuracy: nil),
        WorkoutRoutePoint(latitude: 37.334, longitude: -122.028, timestamp: Date().addingTimeInterval(120), horizontalAccuracy: nil)
    ])
    .padding()
}
#endif
