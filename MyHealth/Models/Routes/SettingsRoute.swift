//
//  SettingsRoute.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum SettingsRoute: Hashable {
    case main
    case section(String)

    public init(section: String) {
        self = .section(section)
    }
}
