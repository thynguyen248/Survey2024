//
//  SurveyNetworkService.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 17/08/2024.
//

import Foundation

protocol NetworkService {
    func request<E: Endpoint>(endpoint: E) async throws -> E.ReturnType
}

final class NetworkServiceImpl: NetworkService {
    private let apiClient: APIClient
    private let tokenProvider: TokenProvider

    init(apiClient: APIClient = APIClientImpl(),
         tokenProvider: TokenProvider = TokenProviderImpl()) {
        self.apiClient = apiClient
        self.tokenProvider = tokenProvider
    }

    func request<E: Endpoint>(endpoint: E) async throws -> E.ReturnType {
        if tokenProvider.shouldRefreshToken {
            try await tokenProvider.refreshToken()
        }
        return try await apiClient.request(endpoint: endpoint)
    }
}
