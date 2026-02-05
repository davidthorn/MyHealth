//
//  HydrationAddEntryViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation

@MainActor
public final class HydrationAddEntryViewModel: ObservableObject {
    @Published public var amountText: String
    @Published public var date: Date
    @Published public private(set) var errorMessage: String?
    @Published public private(set) var isSaving: Bool

    private let service: HydrationEntryServiceProtocol

    public init(service: HydrationEntryServiceProtocol, date: Date = Date()) {
        self.service = service
        self.amountText = ""
        self.date = date
        self.errorMessage = nil
        self.isSaving = false
    }

    public var canSave: Bool {
        Double(amountText.replacingOccurrences(of: ",", with: ".")) != nil
    }

    public func save() async -> Bool {
        guard let amount = Double(amountText.replacingOccurrences(of: ",", with: ".")) else {
            errorMessage = "Enter a valid amount."
            return false
        }
        isSaving = true
        errorMessage = nil
        let authorized = await service.requestWriteAuthorization()
        guard authorized else {
            isSaving = false
            errorMessage = "Write access is required to save hydration."
            return false
        }
        do {
            try await service.saveHydration(amountMilliliters: amount, date: date)
            isSaving = false
            return true
        } catch {
            isSaving = false
            errorMessage = "Could not save hydration. Please try again."
            return false
        }
    }
}
