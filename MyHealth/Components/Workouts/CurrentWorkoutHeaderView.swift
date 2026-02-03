//
//  CurrentWorkoutHeaderView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct CurrentWorkoutHeaderView: View {
    private let session: WorkoutSession
    private let elapsedText: String?

    public init(session: WorkoutSession, elapsedText: String?) {
        self.session = session
        self.elapsedText = elapsedText
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(session.type.displayName)
                .font(.title2.weight(.bold))
            if let startedAt = session.startedAt {
                Text("Started at \(startedAt.formatted(date: .abbreviated, time: .shortened))")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                Text("Ready to start")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            if let elapsedText {
                Text(elapsedText)
                    .font(.title3.weight(.semibold))
            }
        }
    }
}

#if DEBUG
#Preview {
    CurrentWorkoutHeaderView(
        session: WorkoutSession(
            type: .running,
            startedAt: Date().addingTimeInterval(-900),
            status: .active,
            pausedAt: nil,
            totalPausedSeconds: 0
        ),
        elapsedText: "15:00"
    )
    .padding()
}
#endif
