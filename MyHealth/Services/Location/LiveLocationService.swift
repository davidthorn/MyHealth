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
    private var authorizationContinuation: AsyncStream<CLAuthorizationStatus>.Continuation?
    private var lastLocation: CLLocation?
    
    public override init() {
        self.manager = CLLocationManager()
        super.init()
        manager.delegate = self
        manager.activityType = .fitness
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 0
    }
    
    public func locationUpdates() -> AsyncStream<WorkoutRoutePoint> {
        AsyncStream { continuation in
            self.continuation?.finish()
            self.continuation = continuation
            continuation.onTermination = { _ in
                Task { @MainActor [weak self] in
                    self?.manager.stopUpdatingLocation()
                    self?.continuation = nil
                    self?.lastLocation = nil
                }
            }
        }
    }

    public func currentLocation() -> WorkoutRoutePoint? {
        guard isAuthorized else { return nil }
        manager.requestLocation()
        guard let location = manager.location ?? lastLocation else { return nil }
        return WorkoutRoutePoint(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            timestamp: location.timestamp,
            horizontalAccuracy: location.horizontalAccuracy
        )
    }

    public func currentAuthorizationStatus() -> CLAuthorizationStatus {
        manager.authorizationStatus
    }

    public func authorizationUpdates() -> AsyncStream<CLAuthorizationStatus> {
        AsyncStream { continuation in
            self.authorizationContinuation?.finish()
            self.authorizationContinuation = continuation
            continuation.yield(self.manager.authorizationStatus)
            continuation.onTermination = { _ in
                Task { @MainActor [weak self] in
                    self?.authorizationContinuation = nil
                }
            }
        }
    }

    public func requestWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
    }

    public func requestAlwaysAuthorization() {
        manager.requestAlwaysAuthorization()
    }

    public func startLocationUpdates() {
        guard isAuthorized else { return }
        manager.startUpdatingLocation()
    }

    public func stopLocationUpdates() {
        manager.stopUpdatingLocation()
    }
}

extension LiveLocationService: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationContinuation?.yield(manager.authorizationStatus)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        let point = WorkoutRoutePoint(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            timestamp: location.timestamp,
            horizontalAccuracy: location.horizontalAccuracy
        )
        if let continuation = continuation {
            continuation.yield(point)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Swallow transient location errors; a later update may succeed.
    }
}

private extension LiveLocationService {
    var isAuthorized: Bool {
        manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways
    }
}
