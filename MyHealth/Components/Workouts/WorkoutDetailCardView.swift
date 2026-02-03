//
//  WorkoutDetailCardView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI

public struct WorkoutDetailCardView<Content: View>: View {
    private let title: String?
    private let accentColor: Color?
    private let actionTitle: String?
    private let action: (() -> Void)?
    private let content: Content

    public init(
        title: String? = nil,
        accentColor: Color? = nil,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.accentColor = accentColor
        self.actionTitle = actionTitle
        self.action = action
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if title != nil || actionTitle != nil {
                HStack(alignment: .firstTextBaseline) {
                    if let title {
                        Text(title)
                            .font(.headline)
                    }
                    Spacer()
                    if let actionTitle, let action {
                        Button(actionTitle, action: action)
                            .font(.subheadline.weight(.semibold))
                    }
                }
            }

            content
        }
        .padding(16)
        .background(backgroundView)
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(borderColor, lineWidth: 1)
        )
    }
}

private extension WorkoutDetailCardView {
    var backgroundView: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(backgroundFill)
    }

    var backgroundFill: AnyShapeStyle {
        if let accentColor {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [accentColor.opacity(0.28), accentColor.opacity(0.08)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        return AnyShapeStyle(Color(UIColor.secondarySystemGroupedBackground))
    }

    var borderColor: Color {
        if let accentColor {
            return accentColor.opacity(0.25)
        }
        return Color(UIColor.separator).opacity(0.2)
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 12) {
        WorkoutDetailCardView(title: "Overview") {
            Text("Card content")
        }
        WorkoutDetailCardView(title: "Accent", accentColor: .orange) {
            Text("Accent card")
        }
    }
    .padding()
}
#endif
