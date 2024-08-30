//
//  ErrorResponse.swift
//  Survey2024
//
//  Created by Thy Nguyen on 8/24/24.
//

import Foundation

enum AppError: LocalizedError, Equatable {
    case badRequest          // 400
    case unauthorized        // 401
    case clientError         // Other 40x
    case internalServerError // 500
    case serverError         // Other 50x
    case decodingError
    case customError(_ error: ErrorResponse)
    case unknownError
    
    init(statusCode: Int) {
        switch statusCode {
        case 400:
            self = .badRequest
        case 401:
            self = .unauthorized
        case 400...499:
            self = .clientError
        case 500:
            self = .internalServerError
        case 500...599:
            self = .serverError
        default:
            self = .unknownError
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return NSLocalizedString("Bad Request. Please check your input and try again.", comment: "400 Bad Request")
        case .unauthorized:
            return NSLocalizedString("Unauthorized. Please log in and try again.", comment: "401 Unauthorized")
        case .internalServerError:
            return NSLocalizedString("Internal Server Error. Please try again later.", comment: "500 Internal Server Error")
        case .clientError:
            return NSLocalizedString("Something went wrong with your request. Please check and try again.", comment: "Client Error (40x)")
        case .serverError:
            return NSLocalizedString("The server encountered an error. Please try again later.", comment: "Server Error (50x)")
        case .decodingError:
            return NSLocalizedString("We encountered an issue while processing your data. Please try again later.", comment: "")
        case .unknownError:
            return NSLocalizedString("An unknown error occurred. Please try again.", comment: "Unknown Error")
        case .customError(let error):
            return error.errors?.first?.detail
        }
    }
}

struct ErrorResponse: Decodable, Equatable {
    let errors: [ErrorDetail]?
}

struct ErrorDetail: Decodable, Equatable {
    let detail: String?
    let code: CustomErrorCode?
}

enum CustomErrorCode: String, Decodable, Equatable {
    case login = "invalid_email_or_password"
}
