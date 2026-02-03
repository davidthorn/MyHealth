//
//  CurrentWorkoutControlsView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct CurrentWorkoutControlsView: View {
    private let status: WorkoutSessionStatus
    private let canStart: Bool
    private let showStart: Bool
    private let onStart: () -> Void
    private let onPause: () -> Void
    private let onResume: () -> Void
    private let onEnd: () -> Void

    public init(
        status: WorkoutSessionStatus,
        canStart: Bool,
        showStart: Bool,
        onStart: @escaping () -> Void,
        onPause: @escaping () -> Void,
        onResume: @escaping () -> Void,
        onEnd: @escaping () -> Void
    ) {
        self.status = status
        self.canStart = canStart
        self.showStart = showStart
        self.onStart = onStart
        self.onPause = onPause
        self.onResume = onResume
        self.onEnd = onEnd
    }

    public var body: some View {
        HStack(spacing: 12) {
            switch status {
            case .notStarted:
                if showStart {
                    Button(action: onStart) {
                        Text("Start")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!canStart)
                }
            case .paused:
                Button(action: onResume) {
                    Text("Resume")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            case .active:
                Button(action: onPause) {
                    Text("Pause")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            default:
                EmptyView()
            }

            Button(role: .destructive, action: onEnd) {
                Text("End")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 16) {
        CurrentWorkoutControlsView(
            status: .notStarted,
            canStart: true,
            showStart: true,
            onStart: {},
            onPause: {},
            onResume: {},
            onEnd: {}
        )
        CurrentWorkoutControlsView(
            status: .active,
            canStart: true,
            showStart: true,
            onStart: {},
            onPause: {},
            onResume: {},
            onEnd: {}
        )
        CurrentWorkoutControlsView(
            status: .paused,
            canStart: true,
            showStart: true,
            onStart: {},
            onPause: {},
            onResume: {},
            onEnd: {}
        )
    }
    .padding()
}
#endif
