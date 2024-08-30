//
//  LoginAPI.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 17/08/2024.
//

import Foundation

struct LoginEndpoint: Endpoint, Encodable {
    typealias ReturnType = AccessTokenResponseDTO

    var path: String {
        "api/v1/oauth/token"
    }

    var method: HTTPMethod {
        .post
    }

    var body: [String : Any]? {
        toDictionary(encoder: SurveyEncoder.encoder)
    }

    private let email: String
    private let password: String
    private let grantType: GrantType = .password
    private let clientId = APIConstants.key
    private let clientSecret = APIConstants.secret

    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
