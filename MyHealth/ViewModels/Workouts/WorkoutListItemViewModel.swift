//
//  WorkoutListItemViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models
import SwiftUI

@MainActor
public final class WorkoutListItemViewModel: ObservableObject {
    @Published public private(set) var title: String
    @Published public private(set) var typeName: String
    @Published public private(set) var timeRange: String
    @Published public private(set) var distanceText: String
    @Published public private(set) var durationText: String
    @Published public private(set) var paceText: String
    @Published public private(set) var averageHeartRateText: String
    @Published public private(set) var routePoints: [WorkoutRoutePoint]
    @Published public private(set) var isOutdoor: Bool
    @Published public private(set) var accentColor: Color

    private let service: WorkoutListItemServiceProtocol
    private let workout: Workout
    private var task: Task<Void, Never>?

    public init(service: WorkoutListItemServiceProtocol, workout: Workout) {
        self.service = service
        self.workout = workout
        self.title = workout.title
        self.typeName = workout.type.displayName
        self.timeRange = ""
        self.distanceText = "—"
        self.durationText = "—"
        self.paceText = "—"
        self.averageHeartRateText = "—"
        self.routePoints = []
        self.isOutdoor = false
        self.accentColor = workout.type.accentColor
    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let service = self?.service, let workout = self?.workout else { return }
            for await update in service.updates(for: workout) {
                guard let self, !Task.isCancelled else { break }
                self.title = update.title
                self.typeName = update.typeName
                self.timeRange = update.timeRange
                self.routePoints = update.routePoints
                self.isOutdoor = !update.routePoints.isEmpty
                self.distanceText = formatDistance(update.distanceMeters)
                self.durationText = formatDuration(update.durationSeconds)
                self.paceText = formatPace(distanceMeters: update.distanceMeters, durationSeconds: update.durationSeconds)
                self.averageHeartRateText = formatHeartRate(update.averageHeartRateBpm)
            }
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
    }

    private func formatDistance(_ meters: Double?) -> String {
        guard let meters else { return "—" }
        let kilometers = meters / 1000
        return String(format: "%.2f km", kilometers)
    }

    private func formatDuration(_ seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: seconds) ?? "—"
    }

    private func formatPace(distanceMeters: Double?, durationSeconds: TimeInterval) -> String {
        guard let meters = distanceMeters, meters > 0 else { return "—" }
        let paceSeconds = durationSeconds / (meters / 1000)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        let pace = formatter.string(from: paceSeconds) ?? "—"
        return "\(pace) /km"
    }

    private func formatHeartRate(_ bpm: Double?) -> String {
        guard let bpm else { return "—" }
        return "\(Int(bpm.rounded())) bpm"
    }
}
