//
//  CardView.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 21/08/2024.
//

import SwiftUI
import Kingfisher

struct CardView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    let viewModel: CardViewModel
    @Binding var selectedCardId: String?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.clear
                // Cover image
                KFImage(viewModel.imageUrl)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geometry.size.width, height: geometry.size.height)

                LinearGradientView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea(.all)
                    .opacity(0.6)

                VStack {
                    Spacer()

                    // Title
                    Text(viewModel.title ?? "")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.bottom, 8)
                        .padding(.horizontal, 24)

                    // Description
                    Text(viewModel.description ?? "")
                        .font(.body)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.bottom, 10)
                        .padding(.horizontal, 24)

                    // Button
                    Button(action: {
                        selectedCardId = viewModel.id
                    }) {
                        Text("Take This Survey")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .clipShape(Capsule())
                    }
                    .padding(.bottom, safeAreaInsets.bottom > 0 ? safeAreaInsets.bottom : 16)
                }
                .padding(.horizontal, 16)
            }

        }
    }
}

struct CardViewModel: Identifiable {
    let id: String
    let imageUrl: URL?
    let title: String?
    let description: String?
}

extension CardViewModel {
    init(survey: Survey) {
        self = .init(id: survey.id, imageUrl: survey.coverImageUrl, title: survey.title, description: survey.description)
    }
}

#Preview {
    @State var id: String? = "123"
    return CardView(viewModel: .init(id: "", imageUrl: URL(string: "https://static.pexels.com/photos/36753/flower-purple-lical-blosso.jpg")!, title: "Working from home Check-In", description: "We would like to know how you feel about our work from home (WFH) experience."), selectedCardId: $id)
}
