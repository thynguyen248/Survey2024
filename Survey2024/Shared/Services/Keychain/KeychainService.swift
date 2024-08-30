//
//  KeychainService.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 17/08/2024.
//

import Foundation
import KeychainAccess

protocol KeychainService {
    func save<T: Codable>(key: String, object: T) throws
    func get<T: Codable>(key: String, type: T.Type) throws -> T?
    func delete(key: String) throws
    
    var accessTokenKey: String { get }
    var accessToken: AccessTokenDTO? { get }
    func saveAccessToken(_ accessToken: AccessTokenDTO?)
}

final class KeychainServiceImpl: KeychainService {
    private let keychain: Keychain

    init(service: String = Bundle.main.bundleIdentifier ?? "") {
        self.keychain = Keychain(service: service)
    }

    func save<T: Codable>(key: String, object: T) throws {
        let data = try SurveyEncoder.encoder.encode(object)
        keychain[data: key] = data
    }

    func get<T: Codable>(key: String, type: T.Type) throws -> T? {
        guard let data = keychain[data: key] else {
            return nil
        }
        return try SurveyDecoder.decoder.decode(T.self, from: data)
    }

    func delete(key: String) throws {
        try keychain.remove(key)
    }
}
