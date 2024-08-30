//
//  BearerTokenInterceptor.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 18/08/2024.
//

import Foundation

final class BearerTokenInterceptor: URLProtocol {
    static var keychainService: KeychainService?

    private var activeTask: URLSessionDataTask?

    override class func canInit(with request: URLRequest) -> Bool {
        // Only intercept HTTP and HTTPS requests that do not already contain an Authorization header
        if let headers = request.allHTTPHeaderFields, headers["Authorization"] != nil {
            return false
        }
        return request.url?.scheme == "http" || request.url?.scheme == "https"
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        Task {
            var newRequest = self.request

            if let token = BearerTokenInterceptor.keychainService?.accessToken?.accessToken {
                newRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            newRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

            // Execute the modified request
            activeTask = URLSession.shared.dataTask(with: newRequest) { data, response, error in
                if let data = data {
                    self.client?.urlProtocol(self, didLoad: data)
                }
                if let response = response {
                    self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                }
                if let error = error {
                    self.client?.urlProtocol(self, didFailWithError: error)
                }
                self.client?.urlProtocolDidFinishLoading(self)
            }
            activeTask?.resume()
        }
    }

    override func stopLoading() {
        activeTask?.cancel()
    }
}
