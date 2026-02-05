//
//  HydrationOverviewUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct HydrationOverviewUpdate: Sendable {
    public let window: HydrationWindow
    public let samples: [NutritionSample]
    public let todayTotalMilliliters: Double?
    public let windowTotalMilliliters: Double?

    public init(
        window: HydrationWindow,
        samples: [NutritionSample],
        todayTotalMilliliters: Double?,
        windowTotalMilliliters: Double?
    ) {
        self.window = window
        self.samples = samples
        self.todayTotalMilliliters = todayTotalMilliliters
        self.windowTotalMilliliters = windowTotalMilliliters
    }
}
