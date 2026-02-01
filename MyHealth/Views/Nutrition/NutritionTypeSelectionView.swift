//
//  NutritionTypeSelectionView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct NutritionTypeSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding private var selectedType: NutritionType

    public init(selectedType: Binding<NutritionType>) {
        self._selectedType = selectedType
    }

    public var body: some View {
        List(NutritionType.allCases) { type in
            Button {
                selectedType = type
                dismiss()
            } label: {
                HStack {
                    Text(type.title)
                        .font(.headline)
                    Spacer()
                    if type == selectedType {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.accentColor)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 10)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
        }
    }
}

#if DEBUG
#Preview("Nutrition Type Selection") {
    NavigationStack {
        NutritionTypeSelectionView(selectedType: .constant(.protein))
    }
}
#endif
