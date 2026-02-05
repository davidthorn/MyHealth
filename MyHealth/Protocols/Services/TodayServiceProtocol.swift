//
//  TodayServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol TodayServiceProtocol {
    func updates() -> AsyncStream<TodayUpdate>
}
