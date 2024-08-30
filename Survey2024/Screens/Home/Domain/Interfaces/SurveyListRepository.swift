//
//  SurveyListRepository.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 21/08/2024.
//

import Foundation

protocol SurveyListRepository {
    func getSurveyList(page: Int, pageSize: Int) async throws -> SurveyList
}
