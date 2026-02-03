//
//  CurrentWorkoutLocationPermissionView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct CurrentWorkoutLocationPermissionView: View {
    private let isDenied: Bool
    private let onRequest: () -> Void

    public init(isDenied: Bool, onRequest: @escaping () -> Void) {
        self.isDenied = isDenied
        self.onRequest = onRequest
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isDenied ? "location.slash" : "location")
                    .font(.title2)
                    .foregroundStyle(isDenied ? Color.red : Color.accentColor)
                VStack(alignment: .leading, spacing: 6) {
                    Text(isDenied ? "Location Disabled" : "Enable Location")
                        .font(.headline)
                    Text(isDenied
                         ? "Turn on Location Services for MyHealth in Settings to see your route."
                         : "Allow location access to show your current position and route.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            if !isDenied {
                Button(action: onRequest) {
                    Text("Allow Location")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 220, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 16) {
        CurrentWorkoutLocationPermissionView(isDenied: false, onRequest: {})
        CurrentWorkoutLocationPermissionView(isDenied: true, onRequest: {})
    }
    .padding()
}
#endif
