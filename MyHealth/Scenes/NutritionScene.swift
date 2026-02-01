//
//  NutritionScene.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct NutritionScene: View {
    @State private var path: NavigationPath
    private let service: NutritionServiceProtocol
    private let nutritionTypeListService: NutritionTypeListServiceProtocol
    private let nutritionEntryDetailService: NutritionEntryDetailServiceProtocol
    
    public init(
        service: NutritionServiceProtocol,
        nutritionTypeListService: NutritionTypeListServiceProtocol,
        nutritionEntryDetailService: NutritionEntryDetailServiceProtocol
    ) {
        self.service = service
        self.nutritionTypeListService = nutritionTypeListService
        self.nutritionEntryDetailService = nutritionEntryDetailService
        self._path = State(initialValue: NavigationPath())
    }
    
    public var body: some View {
        NavigationStack(path: $path) {
            NutritionView(service: service)
                .navigationTitle("Nutrition")
                .navigationDestination(for: NutritionRoute.self) { route in
                    switch route {
                    case .type(let type):
                        NutritionTypeListView(
                            service: nutritionTypeListService,
                            type: type,
                            onAddEntry: { selectedType in
                                path.append(NutritionRoute.newEntryType(selectedType))
                            }
                        )
                        .navigationTitle(type.title)
                    case .entry(let sample):
                        NutritionEntryDetailView(
                            service: nutritionEntryDetailService,
                            sample: sample,
                            isNewEntry: false
                        )
                    case .newEntry:
                        let type = NutritionType.energy
                        let sample = NutritionSample(
                            type: type,
                            date: Date(),
                            value: 0,
                            unit: type.unit
                        )
                        NutritionEntryDetailView(
                            service: nutritionEntryDetailService,
                            sample: sample,
                            isNewEntry: true
                        )
                    case .newEntryType(let type):
                        let sample = NutritionSample(
                            type: type,
                            date: Date(),
                            value: 0,
                            unit: type.unit
                        )
                        NutritionEntryDetailView(
                            service: nutritionEntryDetailService,
                            sample: sample,
                            isNewEntry: true
                        )
                    }
                }
        }
        .tabItem {
            Label("Nutrition", systemImage: "fork.knife")
        }
    }
}

#if DEBUG
#Preview("Nutrition") {
    NutritionScene(
        service: AppServices.shared.nutritionService,
        nutritionTypeListService: AppServices.shared.nutritionTypeListService,
        nutritionEntryDetailService: AppServices.shared.nutritionEntryDetailService
    )
}
#endif
