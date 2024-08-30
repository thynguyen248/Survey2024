//
//  RefreshTokenEndpoint.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 17/08/2024.
//

import Foundation

struct RefreshTokenEndpoint: Endpoint, Encodable {
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

    private let refreshToken: String?
    private let grantType: GrantType = .refreshToken
    private let clientId = APIConstants.key
    private let clientSecret = APIConstants.secret

    init(refreshToken: String?) {
        self.refreshToken = refreshToken
    }
}

enum GrantType: String, Codable {
    case refreshToken = "refresh_token"
    case password = "password"
}
