//
//  LiveLocationService.swift
//  MyHealth
//
//  Created by Codex.
//

import CoreLocation
import Foundation
import Models

@MainActor
public final class LiveLocationService: NSObject, LocationServiceProtocol {
    private let manager: CLLocationManager
    private var continuation: AsyncStream<WorkoutRoutePoint>.Continuation?
    private var lastLocation: CLLocation?
    
    public override init() {
        self.manager = CLLocationManager()
        super.init()
        manager.delegate = self
        manager.activityType = .fitness
        manager.pausesLocationUpdatesAutomatically = false
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 1
    }
    
    public func locationUpdates() -> AsyncStream<WorkoutRoutePoint> {
        AsyncStream { continuation in
            self.continuation?.finish()
            self.continuation = continuation
            self.requestAuthorizationIfNeeded()
            continuation.onTermination = { _ in
                Task { @MainActor [weak self] in
                    self?.manager.stopUpdatingLocation()
                    self?.continuation = nil
                    self?.lastLocation = nil
                }
            }
        }
    }
    
    private func requestAuthorizationIfNeeded() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .restricted, .denied:
            manager.stopUpdatingLocation()
        @unknown default:
            manager.stopUpdatingLocation()
        }
    }
}

extension LiveLocationService: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        requestAuthorizationIfNeeded()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        guard location.horizontalAccuracy >= 0, location.horizontalAccuracy <= 25 else { return }
        if let lastLocation, location.distance(from: lastLocation) < 1 {
            return
        }
        lastLocation = location
        let point = WorkoutRoutePoint(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            timestamp: location.timestamp
        )
        if let continuation = continuation {
            continuation.yield(point)
        }
    }
}
