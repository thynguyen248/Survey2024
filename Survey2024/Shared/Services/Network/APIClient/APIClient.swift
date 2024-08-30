//
//  NetworkService.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 17/08/2024.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParams: [String: Any]? { get }
    var body: [String: Any]? { get }
    associatedtype ReturnType: Decodable
}

extension Endpoint {
    var baseURL: String { return APIConstants.baseURL }
    var method: HTTPMethod { return .get }
    var queryParams: [String: Any]? { return nil }
    var body: [String: Any]? { return nil }

    private func requestBodyFrom(params: [String: Any]?) -> Data? {
        guard let params = params else { return nil }
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return nil
        }
        return httpBody
    }

    var urlRequest: URLRequest? {
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
        urlComponents.path = "\(urlComponents.path)\(path)"

        let queryDic: [String: Any] = queryParams ?? [:]
        let queryItems = queryDic.map {
            return URLQueryItem(name: "\($0)", value: "\($1)")
        }
        urlComponents.queryItems = queryItems

        guard let finalURL = urlComponents.url else { return nil }
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.httpBody = requestBodyFrom(params: body)
        return request
    }
}

struct APIConstants {
    static let baseURL = "https://survey-api.nimblehq.co/"
    static let key = "ofzl-2h5ympKa0WqqTzqlVJUiRsxmXQmt5tkgrlWnOE"
    static let secret = "lMQb900L-mTeU-FVTCwyhjsfBwRCxwwbCitPob96cuU"
}

protocol APIClient {
    func request<E: Endpoint>(endpoint: E) async throws -> E.ReturnType
}

final class APIClientImpl: APIClient {
    private var urlSession: URLSession
    private let decoder: JSONDecoder

    init(urlSession: URLSession = URLSession.shared,
         decoder: JSONDecoder = SurveyDecoder.decoder) {
        self.urlSession = urlSession
        self.decoder = decoder
    }

    func request<R: Endpoint>(endpoint: R) async throws -> R.ReturnType {
        guard let urlRequest = endpoint.urlRequest else {
            throw AppError.badRequest
        }
        let (data, response) = try await urlSession.data(for: urlRequest)
        if let response = response as? HTTPURLResponse,
           !((200...299).contains(response.statusCode)) {
            if let customError = try? decoder.decode(ErrorResponse.self, from: data) {
                throw AppError.customError(customError)
            }
            throw AppError(statusCode: response.statusCode)
        }
        do {
            let result = try decoder.decode(R.ReturnType.self, from: data)
            return result
        } catch {
            throw AppError.decodingError
        }
    }
}
