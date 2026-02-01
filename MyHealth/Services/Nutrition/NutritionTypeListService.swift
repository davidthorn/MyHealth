//
//  NutritionTypeListService.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

@MainActor
public final class NutritionTypeListService: NutritionTypeListServiceProtocol, NutritionEntryMutating {
    private var subjects: [NutritionType: CurrentValueSubject<[NutritionSample], Never>] = [:]

    public init() {}

    public func updates(for type: NutritionType) -> AsyncStream<NutritionTypeListUpdate> {
        AsyncStream { continuation in
            let subject = subject(for: type)
            let cancellable = subject.sink { samples in
                let sorted = samples.sorted { $0.date > $1.date }
                continuation.yield(NutritionTypeListUpdate(type: type, samples: sorted))
            }
            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
    }

    public func save(sample: NutritionSample) async throws {
        var samples = subject(for: sample.type).value
        if let index = samples.firstIndex(where: { $0.id == sample.id }) {
            samples[index] = sample
        } else {
            samples.append(sample)
        }
        subject(for: sample.type).send(samples)
    }

    public func delete(id: UUID) async throws {
        for (type, subject) in subjects {
            var samples = subject.value
            if let index = samples.firstIndex(where: { $0.id == id }) {
                samples.remove(at: index)
                subject.send(samples)
                subjects[type] = subject
                break
            }
        }
    }

    private func subject(for type: NutritionType) -> CurrentValueSubject<[NutritionSample], Never> {
        if let existing = subjects[type] {
            return existing
        }
        let seeded = mockSamples(for: type)
        let subject = CurrentValueSubject<[NutritionSample], Never>(seeded)
        subjects[type] = subject
        return subject
    }

    private func baseValue(for type: NutritionType) -> Double {
        switch type {
        case .energy: return 450
        case .water: return 300
        case .caffeine: return 60
        case .protein: return 25
        case .carbohydrate: return 40
        case .fatTotal: return 20
        case .fiber: return 8
        case .sugar: return 15
        case .sodium: return 600
        case .calcium: return 200
        case .iron: return 10
        case .vitaminC: return 45
        default: return 5
        }
    }

    private func mockSamples(for type: NutritionType) -> [NutritionSample] {
        let now = Date()
        let values = (0..<6).map { index in
            let base = baseValue(for: type)
            return base + Double(index) * 1.5
        }
        let samples = values.enumerated().map { offset, value in
            NutritionSample(
                type: type,
                date: now.addingTimeInterval(TimeInterval(-offset * 3 * 60 * 60)),
                value: value,
                unit: type.unit
            )
        }
        return samples.sorted { $0.date > $1.date }
    }
}
