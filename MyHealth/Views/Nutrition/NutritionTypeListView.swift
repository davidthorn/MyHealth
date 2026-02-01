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
    private let onAddEntry: (NutritionType) -> Void

    public init(
        service: NutritionTypeListServiceProtocol,
        type: NutritionType,
        onAddEntry: @escaping (NutritionType) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: NutritionTypeListViewModel(service: service, type: type))
        self.onAddEntry = onAddEntry
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    onAddEntry(viewModel.type)
                } label: {
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
#Preview("Nutrition Type List") {
    NutritionTypeListView(
        service: AppServices.shared.nutritionTypeListService,
        type: .energy,
        onAddEntry: { _ in }
    )
}
#endif
