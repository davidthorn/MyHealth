//
//  CurrentWorkoutGpsStatusView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct CurrentWorkoutGpsStatusView: View {
    private let statusText: String
    private let isLocked: Bool

    public init(statusText: String, isLocked: Bool) {
        self.statusText = statusText
        self.isLocked = isLocked
    }

    public var body: some View {
        Text(statusText)
            .font(.footnote.weight(.medium))
            .foregroundStyle(isLocked ? Color.secondary : Color.orange)
    }
}

#if DEBUG
#Preview {
    VStack(alignment: .leading, spacing: 8) {
        CurrentWorkoutGpsStatusView(statusText: "GPS locked (8 m)", isLocked: true)
        CurrentWorkoutGpsStatusView(statusText: "Waiting for GPS (42 m)", isLocked: false)
    }
    .padding()
}
#endif
