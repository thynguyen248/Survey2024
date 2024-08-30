//
//  TextFieldModifiers.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 19/08/2024.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }

    func loadingOverlay(isLoading: Bool) -> some View {
        overlay(
            Group {
                if isLoading {
                    LoadingView()
                }
            }
        )
    }
}
