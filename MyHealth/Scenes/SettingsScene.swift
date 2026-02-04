//
//  SettingsScene.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct SettingsScene: View {
    @StateObject private var viewModel: SettingsViewModel

    public init(service: SettingsServiceProtocol) {
        _viewModel = StateObject(wrappedValue: SettingsViewModel(service: service))
    }

    public var body: some View {
        VStack(spacing: 16) {
            Text(viewModel.title)
                .font(.title)
            Text("Permissions and preferences")
                .foregroundStyle(.secondary)
        }
        .padding()
            .navigationTitle("Settings")
        .task {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
    }
}
