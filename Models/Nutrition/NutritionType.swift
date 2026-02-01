//
//  NutritionType.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum NutritionType: String, CaseIterable, Codable, Hashable, Identifiable {
    case energy
    case carbohydrate
    case fiber
    case sugar
    case sugarAlcohol
    case fatTotal
    case fatSaturated
    case fatMonounsaturated
    case fatPolyunsaturated
    case cholesterol
    case protein
    case vitaminA
    case thiamin
    case riboflavin
    case niacin
    case pantothenicAcid
    case vitaminB6
    case biotin
    case vitaminB12
    case vitaminC
    case vitaminD
    case vitaminE
    case vitaminK
    case folate
    case calcium
    case chloride
    case iron
    case magnesium
    case phosphorus
    case potassium
    case sodium
    case zinc
    case chromium
    case copper
    case iodine
    case manganese
    case molybdenum
    case selenium
    case caffeine
    case water

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .energy: return "Dietary Energy"
        case .carbohydrate: return "Carbohydrates"
        case .fiber: return "Fiber"
        case .sugar: return "Sugar"
        case .sugarAlcohol: return "Sugar Alcohol"
        case .fatTotal: return "Total Fat"
        case .fatSaturated: return "Saturated Fat"
        case .fatMonounsaturated: return "Monounsaturated Fat"
        case .fatPolyunsaturated: return "Polyunsaturated Fat"
        case .cholesterol: return "Cholesterol"
        case .protein: return "Protein"
        case .vitaminA: return "Vitamin A"
        case .thiamin: return "Thiamin (B1)"
        case .riboflavin: return "Riboflavin (B2)"
        case .niacin: return "Niacin (B3)"
        case .pantothenicAcid: return "Pantothenic Acid (B5)"
        case .vitaminB6: return "Vitamin B6"
        case .biotin: return "Biotin (B7)"
        case .vitaminB12: return "Vitamin B12"
        case .vitaminC: return "Vitamin C"
        case .vitaminD: return "Vitamin D"
        case .vitaminE: return "Vitamin E"
        case .vitaminK: return "Vitamin K"
        case .folate: return "Folate (B9)"
        case .calcium: return "Calcium"
        case .chloride: return "Chloride"
        case .iron: return "Iron"
        case .magnesium: return "Magnesium"
        case .phosphorus: return "Phosphorus"
        case .potassium: return "Potassium"
        case .sodium: return "Sodium"
        case .zinc: return "Zinc"
        case .chromium: return "Chromium"
        case .copper: return "Copper"
        case .iodine: return "Iodine"
        case .manganese: return "Manganese"
        case .molybdenum: return "Molybdenum"
        case .selenium: return "Selenium"
        case .caffeine: return "Caffeine"
        case .water: return "Water"
        }
    }

    public var unit: String {
        switch self {
        case .energy: return "kcal"
        case .carbohydrate, .fiber, .sugar, .sugarAlcohol, .fatTotal, .fatSaturated, .fatMonounsaturated, .fatPolyunsaturated,
             .protein, .cholesterol:
            return "g"
        case .vitaminA, .vitaminD, .vitaminE, .vitaminK:
            return "mcg"
        case .thiamin, .riboflavin, .niacin, .pantothenicAcid, .vitaminB6, .biotin, .vitaminB12, .vitaminC, .folate:
            return "mg"
        case .calcium, .chloride, .iron, .magnesium, .phosphorus, .potassium, .sodium, .zinc, .chromium, .copper,
             .iodine, .manganese, .molybdenum, .selenium:
            return "mg"
        case .caffeine:
            return "mg"
        case .water:
            return "ml"
        }
    }

    public init() {
        self = .energy
    }
}
