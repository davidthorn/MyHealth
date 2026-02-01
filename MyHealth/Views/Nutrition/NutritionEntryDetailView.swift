//
//  NutritionEntryDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct NutritionEntryDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: NutritionEntryDetailViewModel
    @State private var showDeleteConfirm = false

    public init(service: NutritionEntryDetailServiceProtocol, sample: NutritionSample) {
        _viewModel = StateObject(wrappedValue: NutritionEntryDetailViewModel(service: service, sample: sample))
    }

    public var body: some View {
        Form {
            Section("Entry") {
                NavigationLink {
                    NutritionTypeSelectionView(selectedType: $viewModel.type)
                } label: {
                    LabeledContent("Type") {
                        Text(viewModel.type.title)
                    }
                }
                LabeledContent("Unit") {
                    Text(viewModel.type.unit)
                }
                TextField("Value", text: $viewModel.valueText)
                    .keyboardType(.decimalPad)
                DatePicker("Date", selection: $viewModel.date, displayedComponents: [.date, .hourAndMinute])
            }

            if viewModel.hasChanges {
                Section {
                    Button("Save Changes") {
                        Task { [weak viewModel] in
                            await viewModel?.save()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    Button("Reset Changes") {
                        viewModel.resetChanges()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }

            Section {
                Button("Delete Entry", role: .destructive) {
                    showDeleteConfirm = true
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Entry")
        .scrollDismissesKeyboard(.interactively)
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .alert("Delete this entry?", isPresented: $showDeleteConfirm) {
            Button("Delete", role: .destructive) {
                Task { [weak viewModel] in
                    await viewModel?.delete()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this?")
        }
        .onChange(of: viewModel.isDeleted) { _, deleted in
            if deleted {
                dismiss()
            }
        }
        .onChange(of: viewModel.valueText) { _, _ in
            viewModel.updateChangeState()
        }
        .onChange(of: viewModel.type) { _, _ in
            viewModel.updateChangeState()
        }
        .onChange(of: viewModel.date) { _, _ in
            viewModel.updateChangeState()
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
#Preview("Nutrition Entry Detail") {
    NavigationStack {
        NutritionEntryDetailView(
            service: AppServices.shared.nutritionEntryDetailService,
            sample: NutritionSample(type: .protein, date: Date(), value: 22.5, unit: "g")
        )
    }
}
#endif
