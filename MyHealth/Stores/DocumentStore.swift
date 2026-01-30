//
//  DocumentStore.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation

public actor DocumentStore<Model>: Sendable where Model: Codable & Identifiable & Hashable, Model.ID: Hashable {
    public typealias ID = Model.ID

    private let fileURL: URL
    private let subject: CurrentValueSubject<[Model], Never>
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let bootstrapKey: String

    public init(fileName: String? = nil) {
        let name = fileName ?? String(describing: Model.self)
        self.fileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("\(name).json")
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
        self.subject = CurrentValueSubject([])
        self.bootstrapKey = "DocumentStore.bootstrap.\(name)"
    }

    public func stream() -> AsyncStream<[Model]> {
        AsyncStream { continuation in
            let cancellable = subject.sink { value in
                continuation.yield(value)
            }
            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
    }

    public func create(_ item: Model) throws {
        var items = subject.value
        items.append(item)
        subject.send(items)
        try persist(items)
    }

    public func loadAll() throws {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            try persist([])
            subject.send([])
            return
        }
        let data = try Data(contentsOf: fileURL)
        let items = try decoder.decode([Model].self, from: data)
        subject.send(items)
    }

    public func read(id: ID) -> Model? {
        subject.value.first { $0.id == id }
    }

    public func readAll() -> [Model] {
        subject.value
    }

    public func update(_ item: Model) throws {
        var items = subject.value
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index] = item
        subject.send(items)
        try persist(items)
    }

    public func delete(id: ID) throws {
        var items = subject.value
        items.removeAll { $0.id == id }
        subject.send(items)
        try persist(items)
    }

    public func deleteAll() throws {
        let items: [Model] = []
        subject.send(items)
        try persist(items)
    }

    public func bootstrap(_ items: [Model]) throws {
        let defaults = UserDefaults.standard
        guard defaults.bool(forKey: bootstrapKey) == false else { return }
        subject.send(items)
        try persist(items)
        defaults.set(true, forKey: bootstrapKey)
    }

    private func persist(_ items: [Model]) throws {
        let data = try encoder.encode(items)
        try data.write(to: fileURL, options: [.atomic])
    }
}
