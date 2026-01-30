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
        NavigationStack(path: $viewModel.path) {
            VStack(spacing: 16) {
                Text(viewModel.title)
                    .font(.title)
                Text("Permissions and preferences")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("Settings")
            .navigationDestination(for: SettingsRoute.self) { route in
                switch route {
                case .section(let value):
                    Text("Settings: \(value)")
                }
            }
        }
        .task {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
        .tabItem {
            Label("Settings", systemImage: "gearshape")
        }
    }
}
