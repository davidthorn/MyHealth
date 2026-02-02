//
//  HKSample+MetadataStrings.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import HealthKit

extension HKSample {
    nonisolated var metadataStrings: [String: String] {
        let metadata = self.metadata ?? [:]
        return metadata.reduce(into: [String: String]()) { result, item in
            result[String(describing: item.key)] = String(describing: item.value)
        }
    }
}
