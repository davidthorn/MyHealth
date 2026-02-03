//
//  HealthKitWorkoutSession.swift
//
//  A single actor that owns workout lifecycle.
//  - watchOS: uses HKWorkoutSession + HKLiveWorkoutBuilder (real pause/resume).
//  - iOS: uses HKWorkoutBuilder only (no real pause/resume in HealthKit; tracks pause time locally).
//
//  Created by David Thorn on 02.02.26.
//

import Foundation
import HealthKit
import Models

public protocol WorkoutTypeConvertible: Sendable {
    var healthKitActivityType: HKWorkoutActivityType { get }
    var healthKitLocationType: HKWorkoutSessionLocationType { get }
}

public enum HealthKitWorkoutSessionError: Error, Sendable {
    case alreadyActive
    case notActive
    case notSupportedOnThisPlatform
    case authorizationDenied
}

public actor HealthKitWorkoutSession {
    
    private let healthStore: HKHealthStore
    private let authorizationProvider: HealthAuthorizationProviding
    
    // Shared state
    private var startedAt: Date?
    private var pausedAt: Date?
    private var totalPaused: TimeInterval = 0
    
#if os(watchOS)
    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?
    private var sessionDelegateBridge: SessionDelegateBridge?
    private var builderDelegateBridge: BuilderDelegateBridge?
    
    private var finishContinuation: CheckedContinuation<HKWorkout, Error>?
#else
    private var builder: HKWorkoutBuilder?
#endif
    
    public init(
        healthStore: HKHealthStore,
        authorizationProvider: HealthAuthorizationProviding
    ) {
        self.healthStore = healthStore
        self.authorizationProvider = authorizationProvider
    }
    
    // MARK: - Public API
    
    public func start<T: WorkoutTypeConvertible>(
        type: T,
        at startDate: Date = Date()
    ) async throws {
        let authorized = await authorizationProvider.requestCreateWorkoutAuthorization()
        guard authorized else {
            throw HealthKitWorkoutSessionError.authorizationDenied
        }
        guard startedAt == nil else { throw HealthKitWorkoutSessionError.alreadyActive }
        
#if os(watchOS)
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = type.healthKitActivityType
        configuration.locationType = type.healthKitLocationType
        
        let session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
        let builder = session.associatedWorkoutBuilder()
        builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
        
        let sessionBridge = SessionDelegateBridge(actor: self)
        let builderBridge = BuilderDelegateBridge(actor: self)
        
        session.delegate = sessionBridge
        builder.delegate = builderBridge
        
        self.session = session
        self.builder = builder
        self.sessionDelegateBridge = sessionBridge
        self.builderDelegateBridge = builderBridge
        
        self.startedAt = startDate
        self.pausedAt = nil
        self.totalPaused = 0
        
        session.startActivity(with: startDate)
        try await builder.beginCollection(at: startDate)
#else
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = type.healthKitActivityType
        configuration.locationType = type.healthKitLocationType
        
        let builder = HKWorkoutBuilder(
            healthStore: healthStore,
            configuration: configuration,
            device: nil
        )
        
        self.builder = builder
        self.startedAt = startDate
        self.pausedAt = nil
        self.totalPaused = 0
        
        try await builder.beginCollection(at: startDate)
#endif
    }
    
    public func pause(at date: Date = Date()) async throws {
        guard startedAt != nil else { throw HealthKitWorkoutSessionError.notActive }
        guard pausedAt == nil else { return }
        
#if os(watchOS)
        session?.pause()
#endif
        
        pausedAt = date
    }
    
    public func resume(at date: Date = Date()) async throws {
        guard startedAt != nil else { throw HealthKitWorkoutSessionError.notActive }
        guard let pausedAt else { return }
        
        totalPaused += date.timeIntervalSince(pausedAt)
        self.pausedAt = nil
        
#if os(watchOS)
        session?.resume()
#endif
    }
    
    /// Ends the workout and returns the saved HKWorkout.
    public func end(at endDate: Date = Date()) async throws -> HKWorkout {
        guard startedAt != nil else { throw HealthKitWorkoutSessionError.notActive }
        
#if os(watchOS)
        guard let session, let builder else { throw HealthKitWorkoutSessionError.notActive }
        
        // Finish is driven by session state changes; we await the finish continuation.
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<HKWorkout, Error>) in
            self.finishContinuation = continuation
            session.end()
            // When session transitions to .ended, we endCollection + finishWorkout.
            // Completion will resume continuation.
        }
#else
        guard let builder else { throw HealthKitWorkoutSessionError.notActive }
        
        try await builder.endCollection(at: endDate)
        let workout: HKWorkout = try await withCheckedThrowingContinuation { continuation in
            builder.finishWorkout { workout, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let workout else {
                    continuation.resume(throwing: HealthKitWorkoutSessionError.notActive)
                    return
                }
                continuation.resume(returning: workout)
            }
        }
        
        resetState()
        return workout
#endif
    }
    
    // MARK: - watchOS delegate entrypoints
    
#if os(watchOS)
    fileprivate func handleSessionStateChange(
        to newState: HKWorkoutSessionState,
        date: Date
    ) async {
        guard let builder else { return }
        
        if newState == .ended {
            do {
                try await builder.endCollection(at: date)
                
                let workout: HKWorkout = try await withCheckedThrowingContinuation { continuation in
                    builder.finishWorkout { workout, error in
                        if let error {
                            continuation.resume(throwing: error)
                            return
                        }
                        guard let workout else {
                            continuation.resume(throwing: HealthKitWorkoutSessionError.notActive)
                            return
                        }
                        continuation.resume(returning: workout)
                    }
                }
                
                finishContinuation?.resume(returning: workout)
            } catch {
                finishContinuation?.resume(throwing: error)
            }
            
            finishContinuation = nil
            resetState()
        }
    }
    
    fileprivate func handleSessionError(_ error: Error) async {
        finishContinuation?.resume(throwing: error)
        finishContinuation = nil
        resetState()
    }
#endif
    
    // MARK: - Private
    
    private func resetState() {
        startedAt = nil
        pausedAt = nil
        totalPaused = 0
        
#if os(watchOS)
        session = nil
        builder = nil
        sessionDelegateBridge = nil
        builderDelegateBridge = nil
#else
        builder = nil
#endif
    }
}

extension HealthKitWorkoutSession: HealthKitWorkoutSessionManaging {
    public func beginWorkout(type: WorkoutType) async throws {
        try await start(type: type)
    }

    public func pauseWorkout() async throws {
        try await pause()
    }

    public func resumeWorkout() async throws {
        try await resume()
    }

    public func endWorkout() async throws {
        _ = try await end()
    }
}

#if os(watchOS)
// MARK: - Delegate Bridges (required by HealthKit)

private final class SessionDelegateBridge: NSObject, HKWorkoutSessionDelegate {
    unowned let actor: HealthKitWorkoutSession
    
    init(actor: HealthKitWorkoutSession) {
        self.actor = actor
        super.init()
    }
    
    func workoutSession(
        _ workoutSession: HKWorkoutSession,
        didChangeTo toState: HKWorkoutSessionState,
        from fromState: HKWorkoutSessionState,
        date: Date
    ) {
        Task { await actor.handleSessionStateChange(to: toState, date: date) }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        Task { await actor.handleSessionError(error) }
    }
}

private final class BuilderDelegateBridge: NSObject, HKLiveWorkoutBuilderDelegate {
    unowned let actor: HealthKitWorkoutSession
    
    init(actor: HealthKitWorkoutSession) {
        self.actor = actor
        super.init()
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        // Optional: forward events into the actor if you need them.
    }
    
    func workoutBuilder(
        _ workoutBuilder: HKLiveWorkoutBuilder,
        didCollectDataOf collectedTypes: Set<HKSampleType>
    ) {
        // Optional: forward live samples/statistics into the actor if you need them.
    }
}
#endif
