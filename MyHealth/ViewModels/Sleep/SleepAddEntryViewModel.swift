//
//  SleepAddEntryViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models
import Combine

@MainActor
public final class SleepAddEntryViewModel: ObservableObject {
    @Published public var startDate: Date
    @Published public var endDate: Date
    @Published public var category: SleepEntryCategory
    @Published public private(set) var isSaving: Bool
    @Published public private(set) var errorMessage: String?

    private let service: SleepEntryServiceProtocol

    public init(service: SleepEntryServiceProtocol) {
        self.service = service
        let now = Date()
        self.startDate = Calendar.current.date(byAdding: .hour, value: -8, to: now) ?? now
        self.endDate = now
        self.category = .asleep
        self.isSaving = false
        self.errorMessage = nil
    }

    public var durationSeconds: TimeInterval {
        max(endDate.timeIntervalSince(startDate), 0)
    }

    public var durationText: String {
        let totalMinutes = Int(durationSeconds / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }

    public var canSave: Bool {
        endDate > startDate
    }

    public func save() async -> Bool {
        guard canSave else {
            errorMessage = "End time must be after the start time."
            return false
        }
        isSaving = true
        errorMessage = nil
        let authorized = await service.requestWriteAuthorization()
        guard authorized else {
            isSaving = false
            errorMessage = "Health access is required to save sleep."
            return false
        }
        let entry = SleepEntry(
            id: UUID(),
            startDate: startDate,
            endDate: endDate,
            category: category,
            isUserEntered: true,
            sourceName: nil,
            deviceName: nil
        )
        do {
            try await service.saveSleepEntry(entry)
            isSaving = false
            return true
        } catch {
            isSaving = false
            errorMessage = "Unable to save sleep. Please try again."
            return false
        }
    }
}
