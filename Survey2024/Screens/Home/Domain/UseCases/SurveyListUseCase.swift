//
//  SurveyListUseCase.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 21/08/2024.
//

import UIKit

protocol SurveyListUseCase {
    func getSurveyList(page: Int, pageSize: Int) async throws -> SurveyList
}

final class SurveyListUseCaseImpl: SurveyListUseCase {
    private let repository: SurveyListRepository

    init(repository: SurveyListRepository = SurveyListRepositoryImpl()) {
        self.repository = repository
    }

    func getSurveyList(page: Int, pageSize: Int) async throws -> SurveyList {
        try await repository.getSurveyList(page: page, pageSize: pageSize)
    }
}
