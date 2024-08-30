//
//  AccessTokenService.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 17/08/2024.
//

import Foundation

protocol TokenProvider: AnyObject {
    var accessToken: String? { get }
    var refreshToken: String? { get }
    var expiredTimeStamp: Int64? { get }
    var shouldRefreshToken: Bool { get }
    func refreshToken() async throws
}

final class TokenProviderImpl: TokenProvider {
    private let apiClient: APIClient
    private let keychainService: KeychainService
    private let userDefaults: UserDefaults
    private let accessTokenKey = "accessToken"
    private let launchedKey = "launchedKey"

    init(apiClient: APIClient = APIClientImpl(),
         keychainService: KeychainService = KeychainServiceImpl(),
         userDefaults: UserDefaults = .standard) {
        self.apiClient = apiClient
        self.keychainService = keychainService
        self.userDefaults = userDefaults
        if !isLaunched, keychainService.accessToken != nil {
            self.keychainService.saveAccessToken(nil)
        }
        isLaunched = true
    }

    private var isLaunched: Bool {
        get {
            userDefaults.bool(forKey: launchedKey)
        } set {
            userDefaults.set(newValue, forKey: launchedKey)
        }
    }

    var accessToken: String? {
        keychainService.accessToken?.accessToken
    }

    var refreshToken: String? {
        keychainService.accessToken?.refreshToken
    }

    var expiredTimeStamp: Int64? {
        guard let createdAt = keychainService.accessToken?.createdAt, let expiredIn = keychainService.accessToken?.expiresIn else {
            return nil
        }
        return createdAt + expiredIn
    }

    var shouldRefreshToken: Bool {
        guard let expiredTimeStamp = expiredTimeStamp else {
            return false
        }
        let currentTimeStamp = Date().timeIntervalSince1970
        return Int64(currentTimeStamp) > expiredTimeStamp
    }

    func refreshToken() async throws {
        let endpoint = RefreshTokenEndpoint(refreshToken: refreshToken)
        let accessTokenDTO = try await apiClient.request(endpoint: endpoint).data?.attributes
        keychainService.saveAccessToken(accessTokenDTO)
    }
}
