//
//  NutritionType+HealthKit.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import HealthKit
import Models

internal extension NutritionType {
    var quantityIdentifier: HKQuantityTypeIdentifier? {
        switch self {
        case .energy: return .dietaryEnergyConsumed
        case .carbohydrate: return .dietaryCarbohydrates
        case .fiber: return .dietaryFiber
        case .sugar: return .dietarySugar
        case .fatTotal: return .dietaryFatTotal
        case .fatSaturated: return .dietaryFatSaturated
        case .fatMonounsaturated: return .dietaryFatMonounsaturated
        case .fatPolyunsaturated: return .dietaryFatPolyunsaturated
        case .cholesterol: return .dietaryCholesterol
        case .protein: return .dietaryProtein
        case .vitaminA: return .dietaryVitaminA
        case .thiamin: return .dietaryThiamin
        case .riboflavin: return .dietaryRiboflavin
        case .niacin: return .dietaryNiacin
        case .pantothenicAcid: return .dietaryPantothenicAcid
        case .vitaminB6: return .dietaryVitaminB6
        case .biotin: return .dietaryBiotin
        case .vitaminB12: return .dietaryVitaminB12
        case .vitaminC: return .dietaryVitaminC
        case .vitaminD: return .dietaryVitaminD
        case .vitaminE: return .dietaryVitaminE
        case .vitaminK: return .dietaryVitaminK
        case .folate: return .dietaryFolate
        case .calcium: return .dietaryCalcium
        case .chloride: return .dietaryChloride
        case .iron: return .dietaryIron
        case .magnesium: return .dietaryMagnesium
        case .phosphorus: return .dietaryPhosphorus
        case .potassium: return .dietaryPotassium
        case .sodium: return .dietarySodium
        case .zinc: return .dietaryZinc
        case .chromium: return .dietaryChromium
        case .copper: return .dietaryCopper
        case .iodine: return .dietaryIodine
        case .manganese: return .dietaryManganese
        case .molybdenum: return .dietaryMolybdenum
        case .selenium: return .dietarySelenium
        case .caffeine: return .dietaryCaffeine
        case .water: return .dietaryWater
        @unknown default: return nil
        }
    }

    var quantityUnit: HKUnit {
        switch self {
        case .energy:
            return .kilocalorie()
        case .water:
            return .literUnit(with: .milli)
        case .vitaminA, .vitaminD, .vitaminE, .vitaminK, .biotin:
            return .gramUnit(with: .micro)
        case .carbohydrate, .fiber, .sugar, .fatTotal, .fatSaturated, .fatMonounsaturated,
             .fatPolyunsaturated, .protein:
            return .gram()
        case .cholesterol:
            return .gramUnit(with: .milli)
        case .thiamin, .riboflavin, .niacin, .pantothenicAcid, .vitaminB6, .vitaminB12, .vitaminC, .folate,
             .calcium, .chloride, .iron, .magnesium, .phosphorus, .potassium, .sodium, .zinc, .chromium, .copper,
             .iodine, .manganese, .molybdenum, .selenium, .caffeine:
            return .gramUnit(with: .milli)
        @unknown default:
            return .gram()
        }
    }
}
