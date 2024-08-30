//
//  GradientView.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 19/08/2024.
//

import SwiftUI

struct LinearGradientView: View {
    let topColor: Color
    let bottomColor: Color

    init(topColor: Color = Color.black.opacity(0.0),
         bottomColor: Color = Color.black.opacity(1.0)) {
        self.topColor = topColor
        self.bottomColor = bottomColor
    }

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.black.opacity(0.0),
                Color.black.opacity(1.0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

#Preview {
    LinearGradientView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
}
