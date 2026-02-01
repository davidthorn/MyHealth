//
//  NutritionEntryDetailViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class NutritionEntryDetailViewModel: ObservableObject {
    @Published public private(set) var sample: NutritionSample
    @Published public var valueText: String
    @Published public var type: NutritionType
    @Published public var date: Date
    @Published public var errorMessage: String?
    @Published public private(set) var isDeleted: Bool
    @Published public private(set) var hasChanges: Bool

    private let service: NutritionEntryDetailServiceProtocol
    private var task: Task<Void, Never>?
    private var originalSample: NutritionSample

    public init(service: NutritionEntryDetailServiceProtocol, sample: NutritionSample) {
        self.service = service
        self.sample = sample
        self.originalSample = sample
        self.valueText = String(format: "%.1f", sample.value)
        self.type = sample.type
        self.date = sample.date
        self.errorMessage = nil
        self.isDeleted = false
        self.hasChanges = false
    }

    public func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let service = self?.service, let sample = self?.sample else { return }
            for await update in service.updates(for: sample) {
                guard let self, !Task.isCancelled else { break }
                if self.hasChanges {
                    continue
                }
                self.sample = update.sample
                self.originalSample = update.sample
                self.valueText = String(format: "%.1f", update.sample.value)
                self.type = update.sample.type
                self.date = update.sample.date
                self.hasChanges = false
            }
        }
    }

    public func stop() {
        task?.cancel()
        task = nil
    }

    public func save() async {
        guard let value = Double(valueText) else {
            errorMessage = "Enter a valid value."
            return
        }
        let updated = NutritionSample(
            id: sample.id,
            type: type,
            date: date,
            value: value,
            unit: type.unit
        )
        do {
            try await service.save(sample: updated)
            sample = updated
            originalSample = updated
            hasChanges = false
            errorMessage = nil
        } catch {
            errorMessage = "Failed to save entry."
        }
    }

    public func resetChanges() {
        valueText = String(format: "%.1f", originalSample.value)
        type = originalSample.type
        date = originalSample.date
        hasChanges = false
    }

    public func delete() async {
        do {
            try await service.delete(id: sample.id)
            isDeleted = true
        } catch {
            errorMessage = "Failed to delete entry."
        }
    }

    public func updateChangeState() {
        guard let value = Double(valueText) else {
            let valueChanged = valueText != String(format: "%.1f", originalSample.value)
            let typeChanged = type != originalSample.type
            hasChanges = valueChanged || typeChanged || date != originalSample.date
            return
        }
        let valueChanged = abs(value - originalSample.value) > 0.0001
        let typeChanged = type != originalSample.type
        hasChanges = valueChanged || typeChanged || date != originalSample.date
    }
}
