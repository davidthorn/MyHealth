//
//  NutritionView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct NutritionView: View {
    @StateObject private var viewModel: NutritionViewModel

    public init(service: NutritionServiceProtocol) {
        _viewModel = StateObject(wrappedValue: NutritionViewModel(service: service))
    }

    public var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                if let summary = viewModel.summary {
                    MetricsNutritionSummaryCardView(
                        summary: summary,
                        selectedWindow: Binding(
                            get: { viewModel.window },
                            set: { viewModel.selectWindow($0) }
                        ),
                        windows: viewModel.windows
                    )
                }
                ForEach(viewModel.filteredTypes, id: \.self) { type in
                    NavigationLink(value: viewModel.route(for: type)) {
                        NutritionTypeRowView(type: type)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .scrollIndicators(.hidden)  
        .searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer(displayMode: .always))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: NutritionRoute.newEntry) {
                    Image(systemName: "plus.circle.fill")
                }
                .accessibilityLabel("Add Nutrition Entry")
            }
        }
        .task {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
    }
}

#if DEBUG
#Preview("Nutrition View") {
    NutritionView(service: AppServices.shared.nutritionService)
}
#endif
