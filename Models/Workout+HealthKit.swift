//
//  Workout+HealthKit.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit

public extension Workout {
    init?(healthKitWorkout: HKWorkout) {
        guard let type = WorkoutType(healthKitActivityType: healthKitWorkout.workoutActivityType) else {
            return nil
        }
        let metadata = healthKitWorkout.metadata?.reduce(into: [String: String]()) { result, pair in
            result[pair.key] = String(describing: pair.value)
        }
        let indoorFlag = healthKitWorkout.metadata?[HKMetadataKeyIndoorWorkout] as? NSNumber
        let weatherTemperature = (healthKitWorkout.metadata?[HKMetadataKeyWeatherTemperature] as? HKQuantity)?
            .doubleValue(for: .degreeCelsius())
        let weatherHumidity = (healthKitWorkout.metadata?[HKMetadataKeyWeatherHumidity] as? NSNumber).map {
            $0.doubleValue * 100
        }
        let weatherConditionRaw = (healthKitWorkout.metadata?[HKMetadataKeyWeatherCondition] as? NSNumber)?
            .intValue
        let weatherCondition = weatherConditionRaw.flatMap(Workout.weatherConditionLabel)
        let weatherSymbol = weatherConditionRaw.flatMap(Workout.weatherConditionSymbolName)
        let locationTypeRaw: Int? = indoorFlag.map { $0.boolValue ? 1 : 2 }

        self.init(
            id: healthKitWorkout.uuid,
            title: type.displayName,
            type: type,
            startedAt: healthKitWorkout.startDate,
            endedAt: healthKitWorkout.endDate,
            sourceBundleIdentifier: healthKitWorkout.sourceRevision.source.bundleIdentifier,
            sourceName: healthKitWorkout.sourceRevision.source.name,
            deviceName: healthKitWorkout.device?.name,
            activityTypeRawValue: Int(healthKitWorkout.workoutActivityType.rawValue),
            locationTypeRawValue: locationTypeRaw,
            durationSeconds: healthKitWorkout.duration,
            totalDistanceMeters: healthKitWorkout.totalDistance?.doubleValue(for: .meter()),
            totalEnergyBurnedKilocalories: healthKitWorkout.totalEnergyBurned?.doubleValue(for: .kilocalorie()),
            totalElevationGainMeters: nil,
            weatherTemperatureCelsius: weatherTemperature,
            weatherHumidityPercent: weatherHumidity,
            weatherCondition: weatherCondition,
            weatherConditionRawValue: weatherConditionRaw,
            weatherConditionSymbolName: weatherSymbol,
            metadata: metadata?.isEmpty == false ? metadata : nil
        )
    }
}

private extension Workout {
    static func weatherConditionLabel(_ rawValue: Int) -> String {
        guard let condition = HKWeatherCondition(rawValue: rawValue) else { return "Unknown" }
        switch condition {
        case .none: return "None"
        case .clear: return "Clear"
        case .fair: return "Fair"
        case .partlyCloudy: return "Partly Cloudy"
        case .mostlyCloudy: return "Mostly Cloudy"
        case .cloudy: return "Cloudy"
        case .foggy: return "Foggy"
        case .haze: return "Haze"
        case .windy: return "Windy"
        case .blustery: return "Blustery"
        case .smoky: return "Smoky"
        case .dust: return "Dust"
        case .snow: return "Snow"
        case .hail: return "Hail"
        case .sleet: return "Sleet"
        case .freezingDrizzle: return "Freezing Drizzle"
        case .freezingRain: return "Freezing Rain"
        case .mixedRainAndHail: return "Mixed Rain and Hail"
        case .mixedRainAndSnow: return "Mixed Rain and Snow"
        case .mixedRainAndSleet: return "Mixed Rain and Sleet"
        case .mixedSnowAndSleet: return "Mixed Snow and Sleet"
        case .drizzle: return "Drizzle"
        case .scatteredShowers: return "Scattered Showers"
        case .showers: return "Showers"
        case .thunderstorms: return "Thunderstorms"
        case .tropicalStorm: return "Tropical Storm"
        case .hurricane: return "Hurricane"
        case .tornado: return "Tornado"
        @unknown default: return "Unknown"
        }
    }

    static func weatherConditionSymbolName(_ rawValue: Int) -> String {
        guard let condition = HKWeatherCondition(rawValue: rawValue) else { return "cloud" }
        switch condition {
        case .none: return "cloud"
        case .clear: return "sun.max.fill"
        case .fair: return "sun.max"
        case .partlyCloudy: return "cloud.sun.fill"
        case .mostlyCloudy: return "cloud.fill"
        case .cloudy: return "cloud.fill"
        case .foggy: return "cloud.fog.fill"
        case .haze: return "cloud.fog"
        case .windy: return "wind"
        case .blustery: return "wind"
        case .smoky: return "smoke.fill"
        case .dust: return "sun.dust.fill"
        case .snow: return "snowflake"
        case .hail: return "cloud.hail.fill"
        case .sleet: return "cloud.sleet.fill"
        case .freezingDrizzle: return "cloud.drizzle.fill"
        case .freezingRain: return "cloud.rain.fill"
        case .mixedRainAndHail: return "cloud.hail.fill"
        case .mixedRainAndSnow: return "cloud.snow.fill"
        case .mixedRainAndSleet: return "cloud.sleet.fill"
        case .mixedSnowAndSleet: return "cloud.sleet.fill"
        case .drizzle: return "cloud.drizzle.fill"
        case .scatteredShowers: return "cloud.sun.rain.fill"
        case .showers: return "cloud.rain.fill"
        case .thunderstorms: return "cloud.bolt.rain.fill"
        case .tropicalStorm: return "tropicalstorm"
        case .hurricane: return "hurricane"
        case .tornado: return "tornado"
        @unknown default: return "cloud"
        }
    }
}
