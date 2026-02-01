//
//  NutritionTypeListView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct NutritionTypeListView: View {
    @StateObject private var viewModel: NutritionTypeListViewModel

    public init(service: NutritionTypeListServiceProtocol, type: NutritionType) {
        _viewModel = StateObject(wrappedValue: NutritionTypeListViewModel(service: service, type: type))
    }

    public var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                if viewModel.samples.isEmpty {
                    ContentUnavailableView(
                        "No \(viewModel.type.title)",
                        systemImage: "fork.knife",
                        description: Text("Entries will appear once available.")
                    )
                    .frame(maxWidth: .infinity)
                } else {
                    ForEach(viewModel.samples) { sample in
                        NavigationLink(value: NutritionRoute.entry(sample)) {
                            NutritionSampleRowView(sample: sample)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .scrollIndicators(.hidden)
        .task {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
    }
}

#if DEBUG
#Preview("Nutrition Type List") {
    NutritionTypeListView(service: AppServices.shared.nutritionTypeListService, type: .energy)
}
#endif
