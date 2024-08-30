//
//  LoginRepository.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 18/08/2024.
//

import Foundation

protocol LoginRepository {
    var isLoggedIn: Bool { get }
    func login(email: String, password: String) async throws
}
