//
//  HydrationAddEntryView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct HydrationAddEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: HydrationAddEntryViewModel

    public init(service: HydrationEntryServiceProtocol) {
        _viewModel = StateObject(wrappedValue: HydrationAddEntryViewModel(service: service))
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section("Amount") {
                    TextField("ml", text: $viewModel.amountText)
                        .keyboardType(.decimalPad)
                }

                Section("Time") {
                    DatePicker("", selection: $viewModel.date, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.graphical)
                }

                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Add Hydration")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(viewModel.isSaving ? "Saving..." : "Save") {
                        Task { @MainActor in
                            let didSave = await viewModel.save()
                            if didSave {
                                dismiss()
                            }
                        }
                    }
                    .disabled(!viewModel.canSave || viewModel.isSaving)
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    HydrationAddEntryView(service: AppServices.shared.hydrationEntryService)
}
#endif
