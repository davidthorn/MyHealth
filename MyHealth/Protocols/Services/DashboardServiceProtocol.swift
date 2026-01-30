//
//  DashboardServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol DashboardServiceProtocol {
    func updates() -> AsyncStream<DashboardUpdate>
}
