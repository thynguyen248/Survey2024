//
//  LoginViewModel.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 17/08/2024.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    // Input
    @Published var email: String = ""
    @Published var password: String = ""
    let didLogin = PassthroughSubject<Void, Never>()

    // Output
    @Published var emailErrorMessage: String?
    @Published var passwordErrorMessage: String?
    @Published var isLoading = false
    @Published var loggedIn = false
    @Published var errorMessage: String?
    @Published var showAlert = false

    private let useCase: LoginUseCase

    init(useCase: LoginUseCase = LoginUseCaseImpl()) {
        self.useCase = useCase
        binding()
    }

    private func binding() {
        $email.map { _ -> String? in
            return nil
        }
        .assign(to: &$emailErrorMessage)
        
        $password.map { _ -> String? in
            return nil
        }
        .assign(to: &$passwordErrorMessage)

        didLogin
            .map { [weak self] _ -> Bool in
                guard let self else {
                    return false
                }
                if email.isEmpty {
                    emailErrorMessage = "Email cannot be empty."
                } else if !email.isValidEmail {
                    emailErrorMessage =  "Please enter a valid email address."
                }
                if password.isEmpty {
                    passwordErrorMessage = "Password cannot be empty."
                }
                return emailErrorMessage == nil && passwordErrorMessage == nil
            }
            .flatMap { [weak self] isValid -> AnyPublisher<Bool, Never> in
                guard let self, isValid else {
                    return Just(false).eraseToAnyPublisher()
                }
                isLoading = true
                return Future { promise in
                    Task {
                        do {
                            try await self.useCase.login(email: self.email, password: self.password)
                            await MainActor.run {
                                self.errorMessage = nil
                                self.showAlert = false
                                self.isLoading = false
                                promise(.success(true))
                            }
                        } catch(let error) {
                            await MainActor.run {
                                if case .customError(let customError) = error as? AppError, 
                                    let message = customError.errors?.first(where: { $0.code == CustomErrorCode.login })?.detail {
                                    self.errorMessage = message
                                } else {
                                    self.errorMessage = (error as? AppError)?.errorDescription
                                }
                                self.showAlert = !(self.errorMessage ?? "").isEmpty
                                self.isLoading = false
                                promise(.success(false))
                            }
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .assign(to: &$loggedIn)
    }
}
