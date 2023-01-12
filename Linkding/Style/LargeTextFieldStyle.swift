//
//  LargeTextFieldStyle.swift
//  Linkding
//
//  Created by bzima on 08.01.2023.
//

import SwiftUI

struct LargeTextFieldStyle: TextFieldStyle {
    @FocusState private var isFocused: Bool
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(8)
            .focused($isFocused)
            .onTapGesture {
                isFocused = true
            }
    }
}
