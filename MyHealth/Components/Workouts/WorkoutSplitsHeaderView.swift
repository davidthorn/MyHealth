//
//  WorkoutSplitsHeaderView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct WorkoutSplitsHeaderView: View {
    public init() {}

    public var body: some View {
        HStack(spacing: 0) {
            Text("KM")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Time")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
            Text("Pace")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
            Text("HR")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .textCase(nil)
    }
}

#if DEBUG
#Preview {
    WorkoutSplitsHeaderView()
        .padding()
}
#endif
