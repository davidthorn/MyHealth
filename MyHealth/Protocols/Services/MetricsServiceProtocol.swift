//
//  MetricsServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol MetricsServiceProtocol {
    func updates() -> AsyncStream<MetricsUpdate>
}
