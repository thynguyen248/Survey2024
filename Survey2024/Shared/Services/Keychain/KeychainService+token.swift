//
//  KeychainService+token.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 18/08/2024.
//

import KeychainAccess
import Foundation

extension KeychainService {
    var accessTokenKey: String {
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            return "\(bundleIdentifier).auth.accessToken"
        } else {
            // Fallback to a default name if bundleIdentifier is nil
            return "default.auth.accessToken"
        }
    }

    var accessToken: AccessTokenDTO? {
        try? get(key: accessTokenKey, type: AccessTokenDTO.self)
    }

    func saveAccessToken(_ accessToken: AccessTokenDTO?) {
        try? save(key: accessTokenKey, object: accessToken)
    }
}
