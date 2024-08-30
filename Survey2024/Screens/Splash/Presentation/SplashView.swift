//
//  SplashView.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 19/08/2024.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var container: DependencyContainer
    @StateObject var viewModel: SplashViewModel

    var body: some View {
        NavigationView {
            ZStack {
                Image("background")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea(.all)

                LinearGradientView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea(.all)
                    .opacity(0.6)

                Image("logo")

                NavigationLink(destination: destinationView,
                               tag: viewModel.navigationSelection ?? .login,
                               selection: $viewModel.navigationSelection) {
                    EmptyView()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                viewModel.trigger.send(())
            }
        }
    }

    private var destinationView: some View {
        Group {
            switch viewModel.navigationSelection {
            case .login:
                container.resolve(LoginView.self)
            case .home:
                container.resolve(HomeView.self)
            case .none:
                EmptyView()
            }
        }
    }
}

#Preview {
    SplashView(viewModel: SplashViewModel())
        .environmentObject(DependencyContainer())
}
