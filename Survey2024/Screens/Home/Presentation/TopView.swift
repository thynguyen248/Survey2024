//
//  TopView.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 21/08/2024.
//

import SwiftUI

struct TopView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(Date().formatted(date: .abbreviated, time: .omitted).uppercased())
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text("Today")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding()

            Spacer()

            Image("avatar")
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding()
        }
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    TopView()
}
