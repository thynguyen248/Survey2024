//
//  AccessTokenDTO.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 17/08/2024.
//

import Foundation

struct AccessTokenResponseDTO: Codable {
    let data: AccessTokenAttributesDTO?
}

struct AccessTokenAttributesDTO: Codable {
    let id: String
    let attributes: AccessTokenDTO?
}

struct AccessTokenDTO: Codable {
    let accessToken: String?
    let tokenType: String?
    let refreshToken: String?
    let expiresIn: Int64?
    let createdAt: Int64?
}
