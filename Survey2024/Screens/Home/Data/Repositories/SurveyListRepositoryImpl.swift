//
//  SurveyListRepositoryImpl.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 21/08/2024.
//

import Foundation

final class SurveyListRepositoryImpl: SurveyListRepository {
    private let networkService: NetworkService

    init(networkService: NetworkService = NetworkServiceImpl()) {
        self.networkService = networkService
    }

    func getSurveyList(page: Int, pageSize: Int) async throws -> SurveyList {
        let endpoint: SurveyListEndpoint = .init(page: page, pageSize: pageSize)
        return try await networkService.request(endpoint: endpoint).mapToDomain()
    }
}
