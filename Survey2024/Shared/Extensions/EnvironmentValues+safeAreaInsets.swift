//
//  EnvironmentValues+safeAreaInsets.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 23/08/2024.
//

import SwiftUI

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
        let insets: UIEdgeInsets = keyWindow?.safeAreaInsets ?? .zero
        return .init(top: insets.top, leading: insets.left, bottom: insets.bottom, trailing: insets.right)
    }
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}
