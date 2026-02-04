//
//  MoreScene.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct MoreScene: View {
    private let insightsService: InsightsServiceProtocol
    private let settingsService: SettingsServiceProtocol
    
    public init(
        insightsService: InsightsServiceProtocol,
        settingsService: SettingsServiceProtocol
    ) {
        self.insightsService = insightsService
        self.settingsService = settingsService
    }
    
    public var body: some View {
        NavigationStack {
            List {
                NavigationLink(value: InsightsRoute.main) {
                    Text("Insights")
                }
                NavigationLink(value: SettingsRoute.main) {
                    Text("Settings")
                    
                }
            }
            .navigationTitle("More")
            
            .navigationDestination(for: SettingsRoute.self) { route in
                switch route {
                case .main:
                    SettingsScene(service: settingsService)
                case .section(_):
                    Text("Section")
                }
            }
            .navigationDestination(for: InsightsRoute.self) { route in
                switch route {
                case .main:
                    InsightsScene(service: insightsService)
                case .insight(let insight):
                    switch insight.type {
                    case .activityHighlights:
                        ActivityHighlightsInsightDetailView(insight: insight)
                    case .workoutHighlights:
                        WorkoutHighlightsInsightDetailView(insight: insight)
                    case .recoveryReadiness:
                        RecoveryReadinessInsightDetailView(insight: insight)
                    }
                }
            }
        }
        .tabItem {
            Label("More", systemImage: "ellipsis.circle")
        }
    }
}

#if DEBUG
#Preview("More") {
    MoreScene(
        insightsService: AppServices.shared.insightsService,
        settingsService: AppServices.shared.settingsService
    )
}
#endif
