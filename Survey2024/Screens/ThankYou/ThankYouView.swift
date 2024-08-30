//
//  ThankYouView.swift
//  Survey2024
//
//  Created by Thy Nguyen on 8/24/24.
//

import SwiftUI
import Lottie

struct ThankYouView: View {
    @Binding var shouldShow: Bool
    
    var body: some View {
        VStack {
            Spacer()
            LottieView(animation: .named("success"))
                .playing(loopMode: .loop)
                .frame(width: 200, height: 200)
            
            Text("Thanks for taking\nthe survey.")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 21 / 255, green: 21 / 255, blue: 26 / 255))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                shouldShow = false
            }
        }
    }
}

#Preview {
    @State var shouldShow = true
    return ThankYouView(shouldShow: $shouldShow)
}
