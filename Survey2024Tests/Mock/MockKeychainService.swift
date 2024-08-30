//
//  MockKeychainService.swift
//  Survey2024Tests
//
//  Created by Thy Nguyen on 8/24/24.
//

import Foundation
@testable import Survey2024

final class MockKeychainService: KeychainService {
    var storage: [String: Data] = [:]
    private let hasAccessToken: Bool
    
    init(hasAccessToken: Bool = false) {
        self.hasAccessToken = hasAccessToken
    }

    func save<T: Codable>(key: String, object: T) throws {
        let data = try SurveyEncoder.encoder.encode(object)
        storage[key] = data
    }

    func get<T: Codable>(key: String, type: T.Type) throws -> T? {
        guard let data = storage[key] else {
            return nil
        }
        return try SurveyDecoder.decoder.decode(T.self, from: data)
    }

    func delete(key: String) throws {
        storage.removeValue(forKey: key)
    }
    
    var accessTokenKey: String {
        "TestSuite"
    }
    
    var accessToken: AccessTokenDTO? {
        if !hasAccessToken {
            return nil
        }
        return .init(accessToken: "123", tokenType: "token", refreshToken: "456", expiresIn: 7200, createdAt: 1724498251)
    }
    
    func saveAccessToken(_ accessToken: AccessTokenDTO?) {
        try? save(key: accessTokenKey, object: accessToken)
    }
}
