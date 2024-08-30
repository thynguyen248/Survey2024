//
//  LoginView.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 17/08/2024.
//

import SwiftUI

struct LoginView: View {
    enum TextFieldType: Hashable {
        case email
        case password
    }

    @EnvironmentObject var container: DependencyContainer
    @StateObject var viewModel: LoginViewModel
    @FocusState private var focusedField: TextFieldType?

    var body: some View {
        NavigationView {
            ZStack {
                background
                VStack(alignment: .center, spacing: 16.0) {
                    logo
                    emailTextField
                    passwordTextField
                    loginButton
                    bottomSpace
                }
                .padding(.horizontal, 24.0)
            }
        }
        .navigationBarBackButtonHidden(true)
        .loadingOverlay(isLoading: viewModel.isLoading)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Login failed"),
                  message: Text(viewModel.errorMessage ?? ""),
                  dismissButton: .default(Text("OK")))
        }
        .onAppear {
            focusedField = .email
        }
    }

    private var background: some View {
        Group {
            Image("background")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
                .blur(radius: 16.0)
            LinearGradientView(topColor: Color.black.opacity(0.2))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
                .opacity(0.6)
        }
    }

    private var logo: some View {
        Group {
            Spacer()
            Image("logo")
            Spacer()
        }
    }

    private var emailTextField: some View {
        Group {
            TextField("", text: $viewModel.email)
                .padding()
                .foregroundColor(.white)
                .background(Color.white.opacity(0.15))
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
                .placeholder(when: viewModel.email.isEmpty) {
                    Text("Email")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                }
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .password
                }
            if let message = viewModel.emailErrorMessage {
                Text(message)
                    .font(.caption2)
                    .foregroundColor(Color.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16.0)
                    .padding(.top, -10.0)
            }
        }
    }

    private var passwordTextField: some View {
        Group {
            HStack {
                SecureField("", text: $viewModel.password)
                    .placeholder(when: viewModel.password.isEmpty) {
                        Text("Password")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .foregroundColor(.white)

                // Forgot button
                Button(action: {
                }) {
                    Text("Forgot?")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(Color.white.opacity(0.15))
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
            .focused($focusedField, equals: .password)
            .submitLabel(.done)
            .onSubmit {
                focusedField = nil
                viewModel.didLogin.send(())
            }

            if let message = viewModel.passwordErrorMessage {
                Text(message)
                    .font(.caption2)
                    .foregroundColor(Color.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16.0)
                    .padding(.top, -10.0)
            }
        }
    }

    private var loginButton: some View {
        NavigationLink(
            destination: container.resolve(HomeView.self),
            isActive: $viewModel.loggedIn
        ) {
            Button(action: {
                viewModel.didLogin.send(())
            }) {
                Text("Log in")
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .background(Color.white)
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
        }
    }

    private var bottomSpace: some View {
        Group {
            Spacer()
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel())
        .environmentObject(DependencyContainer())
}
