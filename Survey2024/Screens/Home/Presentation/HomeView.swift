//
//  HomeView.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 19/08/2024.
//

import SwiftUI
import SwiftUIPullToRefresh

struct HomeView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject var viewModel: HomeViewModel
    @State private var currentIndex = 0
    @State private var selectedCardId: String?

    var body: some View {
        GeometryReader { geometry in
            RefreshableScrollView(onRefresh: { done in
                self.currentIndex = 0
                self.viewModel.pullToRefresh.send(())
                done()
            }) {
                ZStack {
                    cards
                    topView
                    navigationIndicator
                        .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.7)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .ignoresSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .loadingOverlay(isLoading: viewModel.isLoading)
        .onAppear {
            viewModel.trigger.send(())
        }
        .fullScreenCover(isPresented: shouldShowThankYou) {
            ThankYouView(shouldShow: shouldShowThankYou)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"),
                  message: Text(viewModel.errorMessage ?? ""),
                  dismissButton: .default(Text("OK")))
        }
    }

    private var cards: some View {
        TabView(selection: $currentIndex) {
            ForEach(0..<viewModel.dataSource.count, id: \.self) { index in
                CardView(viewModel: viewModel.dataSource[index], selectedCardId: $selectedCardId)
                    .tag(index)
                    .onAppear {
                        if index == viewModel.dataSource.count - 1 {
                            viewModel.trigger.send(())
                        }
                    }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .background(LinearGradientView())
    }

    private var topView: some View {
        VStack {
            TopView()
                .padding(.horizontal, 16)
                .padding(.top, safeAreaInsets.top > 0 ? safeAreaInsets.top : 16)
            Spacer()
        }
    }

    private var navigationIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<viewModel.dataSource.count, id: \.self) { index in
                Capsule()
                    .fill(index == currentIndex ? Color.white : Color.white.opacity(0.5))
                    .frame(width: index == currentIndex ? 16 : 8, height: 8)
                    .animation(.easeInOut, value: currentIndex)
            }
        }
    }
    
    private var shouldShowThankYou: Binding<Bool> {
        Binding(
            get: {
                self.selectedCardId != nil
            },
            set: { shouldShow in
                if !shouldShow {
                    self.selectedCardId = nil
                }
            }
        )
    }
}

#Preview {
    let viewModel: HomeViewModel = .init()
    viewModel.dataSource = [.init(id: "", imageUrl: URL(string: "https://static.pexels.com/photos/36753/flower-purple-lical-blosso.jpg")!, title: "Working from home Check-In", description: "We would like to know how you feel about our work from home (WFH) experience.")]
    return HomeView(viewModel: viewModel)
}
