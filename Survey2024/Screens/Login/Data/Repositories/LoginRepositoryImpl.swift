//
//  LoginRepository.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 18/08/2024.
//

import Foundation

final class LoginRepositoryImpl: LoginRepository {
    private let networkService: NetworkService
    private let keychainService: KeychainService

    init(networkService: NetworkService = NetworkServiceImpl(), keychainService: KeychainService = KeychainServiceImpl()) {
        self.networkService = networkService
        self.keychainService = keychainService
    }

    var isLoggedIn: Bool {
        keychainService.accessToken != nil
    }

    func login(email: String, password: String) async throws {
        let endpoint: LoginEndpoint = .init(email: email, password: password)
        let accessTokenDTO = try await networkService.request(endpoint: endpoint).data?.attributes
        keychainService.saveAccessToken(accessTokenDTO)
    }
}
