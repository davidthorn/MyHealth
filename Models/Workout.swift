//
//  Workout.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct Workout: Hashable, Identifiable, Sendable, Codable {
    public let id: UUID
    public let title: String
    public let type: WorkoutType
    public let startedAt: Date
    public let endedAt: Date
    public let sourceBundleIdentifier: String?
    public let sourceName: String?
    public let deviceName: String?
    public let activityTypeRawValue: Int?
    public let locationTypeRawValue: Int?
    public let durationSeconds: TimeInterval?
    public let totalDistanceMeters: Double?
    public let totalEnergyBurnedKilocalories: Double?
    public let totalElevationGainMeters: Double?
    public let weatherTemperatureCelsius: Double?
    public let weatherHumidityPercent: Double?
    public let weatherCondition: String?
    public let weatherConditionRawValue: Int?
    public let weatherConditionSymbolName: String?
    public let metadata: [String: String]?

    public init(
        id: UUID,
        title: String,
        type: WorkoutType,
        startedAt: Date,
        endedAt: Date,
        sourceBundleIdentifier: String? = nil,
        sourceName: String? = nil,
        deviceName: String? = nil,
        activityTypeRawValue: Int? = nil,
        locationTypeRawValue: Int? = nil,
        durationSeconds: TimeInterval? = nil,
        totalDistanceMeters: Double? = nil,
        totalEnergyBurnedKilocalories: Double? = nil,
        totalElevationGainMeters: Double? = nil,
        weatherTemperatureCelsius: Double? = nil,
        weatherHumidityPercent: Double? = nil,
        weatherCondition: String? = nil,
        weatherConditionRawValue: Int? = nil,
        weatherConditionSymbolName: String? = nil,
        metadata: [String: String]? = nil
    ) {
        self.id = id
        self.title = title
        self.type = type
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.sourceBundleIdentifier = sourceBundleIdentifier
        self.sourceName = sourceName
        self.deviceName = deviceName
        self.activityTypeRawValue = activityTypeRawValue
        self.locationTypeRawValue = locationTypeRawValue
        self.durationSeconds = durationSeconds
        self.totalDistanceMeters = totalDistanceMeters
        self.totalEnergyBurnedKilocalories = totalEnergyBurnedKilocalories
        self.totalElevationGainMeters = totalElevationGainMeters
        self.weatherTemperatureCelsius = weatherTemperatureCelsius
        self.weatherHumidityPercent = weatherHumidityPercent
        self.weatherCondition = weatherCondition
        self.weatherConditionRawValue = weatherConditionRawValue
        self.weatherConditionSymbolName = weatherConditionSymbolName
        self.metadata = metadata
    }
}
