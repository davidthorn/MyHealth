//
//  SleepAddEntryView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct SleepAddEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: SleepAddEntryViewModel

    public init(service: SleepEntryServiceProtocol) {
        _viewModel = StateObject(wrappedValue: SleepAddEntryViewModel(service: service))
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section("Sleep Stage") {
                    Picker("Stage", selection: $viewModel.category) {
                        ForEach(SleepEntryCategory.allCases) { category in
                            Text(category.title).tag(category)
                        }
                    }
                }

                Section("Timing") {
                    DatePicker("Start", selection: $viewModel.startDate, displayedComponents: [.date, .hourAndMinute])
                    DatePicker("End", selection: $viewModel.endDate, displayedComponents: [.date, .hourAndMinute])
                    LabeledContent("Duration", value: viewModel.durationText)
                }

                Section("Saved Details") {
                    LabeledContent("Source", value: "MyHealth")
                    LabeledContent("User Entered", value: "Yes")
                }

                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Add Sleep")
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
    SleepAddEntryView(service: AppServices.shared.sleepEntryService)
}
#endif
