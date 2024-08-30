//
//  LoginUseCase.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 18/08/2024.
//

import Foundation

protocol LoginUseCase {
    var isLoggedIn: Bool { get }
    func login(email: String, password: String) async throws
}

final class LoginUseCaseImpl: LoginUseCase {
    private let repository: LoginRepository

    init(repository: LoginRepository = LoginRepositoryImpl()) {
        self.repository = repository
    }

    var isLoggedIn: Bool {
        repository.isLoggedIn
    }

    func login(email: String, password: String) async throws {
        try await repository.login(email: email, password: password)
    }
}
