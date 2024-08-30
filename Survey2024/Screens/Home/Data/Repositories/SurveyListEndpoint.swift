//
//  SurveyListEndpoint.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 21/08/2024.
//

import Foundation

struct SurveyListEndpoint: Endpoint {
    typealias ReturnType = SurveyResponseDTO

    var path: String {
        "api/v1/surveys"
    }

    var method: HTTPMethod {
        .get
    }

    var queryParams: [String : Any]? {
        PagingParameter(page: page, pageSize: pageSize).toDictionary(encoder: JSONEncoder())
    }

    private let page: Int
    private let pageSize: Int

    init(page: Int, pageSize: Int) {
        self.page = page
        self.pageSize = pageSize
    }
}
