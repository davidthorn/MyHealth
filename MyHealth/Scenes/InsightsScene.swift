//
//  InsightsScene.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct InsightsScene: View {
    private let service: InsightsServiceProtocol

    public init(service: InsightsServiceProtocol) {
        self.service = service
    }

    public var body: some View {
        InsightsView(service: service)
            .navigationTitle("Insights")
    }
}

#if DEBUG
#Preview("Insights") {
    InsightsScene(service: AppServices.shared.insightsService)
}
#endif
