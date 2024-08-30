//
//  LoadingView.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 20/08/2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
            .padding(24)
            .background(Color.black.opacity(0.8))
            .cornerRadius(10)
        }
    }
}

#Preview {
    LoadingView()
}
